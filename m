Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3BAETx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:19:53 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:48832 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3BAETv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:19:51 -0500
Message-ID: <510B425B.1040807@gmail.com>
Date: Fri, 01 Feb 2013 12:19:39 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <5108C9C1.1090707@gmail.com> <51098064.7030902@wwwdotorg.org> <5109EA2A.8020204@gmail.com> <510AA7F8.7070000@wwwdotorg.org>
In-Reply-To: <510AA7F8.7070000@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 01:20 AM, Stephen Warren wrote:
> On 01/30/2013 08:51 PM, Mark Zhang wrote:
>> On 01/31/2013 04:19 AM, Stephen Warren wrote:
>>> On 01/30/2013 12:20 AM, Mark Zhang wrote:
>>>> On 01/30/2013 11:02 AM, Alexandre Courbot wrote:
>>>>> Add support for the Chunghwa CLAA101WA01A display panel.
>>>
>>>>> +static int panel_claa101_get_modes(struct display_entity *entity,
>>>>> +				   const struct videomode **modes)
>>>>> +{
>>>>> +	/* TODO get modes from EDID? */
>>>>
>>>> Why not move the "nvidia,ddc" from encoder's DT to panel's DT? In that
>>>> case, you can get EDID here. I know drm has some helpers to fetch EDID
>>>> but I recall there are some other functions which has no drm
>>>> dependencies which may be suitable for you.
>>>
>>> DDC access is a property of the display controller, not the panel
>>> itself. The panel might be hooked up to a display controller's DDC/I2C
>>> channel as the target, but it isn't the host/controller of the DDC/I2C
>>> channel. As such, placing the nvidia,ddc property into the display
>>> controller node makes sense.
>>
>> Yes, DC triggers the DDC access and is the host of the DDC/I2C channel.
>> So I think it's reasonable to put nvidia,ddc property into the display
>> controller node. But the video mode info in EDID which be fetched via
>> DDC is the property of the panel, so this info should be provided by
>> panel driver.
> 
> No, that makes absolutely no sense at all in the EDID case.
> 
> By the same argument, we'd need a panel driver for every external
> monitor which implemented EDID, just to transfer the EDID results from
> the display controller's DDC channel into the panel driver and back into
> the display controller code, which wants the mode list.
> 

Ah, yes, this is right. We can't write driver for every external monitor
which implements EDID. Although I think it's more reasonable that panel
decides whether the DDC probe is necessary.

> Again, if the mode list is coming from DDC, the display controller
> should retrieve it in exactly the same way it retrieves it for any
> external monitor - by direct control of the DDC channel to read the
> EDID. The only time it makes sense for the panel driver to get involved
> in supplying the mode list is when there's no EDID, so the list must be
> hard-coded into the driver.
> 
