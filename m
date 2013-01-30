Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3A3UTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:19:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42946 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3A3UTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:19:52 -0500
Message-ID: <51098064.7030902@wwwdotorg.org>
Date: Wed, 30 Jan 2013 13:19:48 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <5108C9C1.1090707@gmail.com>
In-Reply-To: <5108C9C1.1090707@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 12:20 AM, Mark Zhang wrote:
> On 01/30/2013 11:02 AM, Alexandre Courbot wrote:
>> Add support for the Chunghwa CLAA101WA01A display panel.

>> +static int panel_claa101_get_modes(struct display_entity *entity,
>> +				   const struct videomode **modes)
>> +{
>> +	/* TODO get modes from EDID? */
> 
> Why not move the "nvidia,ddc" from encoder's DT to panel's DT? In that
> case, you can get EDID here. I know drm has some helpers to fetch EDID
> but I recall there are some other functions which has no drm
> dependencies which may be suitable for you.

DDC access is a property of the display controller, not the panel
itself. The panel might be hooked up to a display controller's DDC/I2C
channel as the target, but it isn't the host/controller of the DDC/I2C
channel. As such, placing the nvidia,ddc property into the display
controller node makes sense.

Re: the other discussion in this thread: Probably the simplest is if
tegradrm/other-CDF-users do something like:

1) If DDC I2C channel available for this display channel, query DDC.
2) If not, or perhaps also if that fails, query the panel driver for the
mode list.

That would cover all bases very simply.
