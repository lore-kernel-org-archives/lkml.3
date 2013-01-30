Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab3A3II4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:08:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5649 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3A3IIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:08:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 30 Jan 2013 00:08:24 -0800
Message-ID: <5108D505.10205@nvidia.com>
Date: Wed, 30 Jan 2013 16:08:37 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Alex Courbot <acourbot@nvidia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <5108C9C1.1090707@gmail.com> <5108CB4F.7000103@nvidia.com> <20130130074852.GB17547@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130130074852.GB17547@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 03:48 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Wed, Jan 30, 2013 at 04:27:11PM +0900, Alex Courbot wrote:
>> On 01/30/2013 04:20 PM, Mark Zhang wrote:
> [...]
>>>> +static int panel_claa101_get_modes(struct display_entity *entity,
>>>> +				   const struct videomode **modes)
>>>> +{
>>>> +	/* TODO get modes from EDID? */
>>>
>>> Why not move the "nvidia,ddc" from encoder's DT to panel's DT? In that
>>> case, you can get EDID here. I know drm has some helpers to fetch EDID
>>> but I recall there are some other functions which has no drm
>>> dependencies which may be suitable for you.
>>
>> I explained this in the cover letter - I'm not sure we want to have
>> a dependency on DRM here, as CDF entities could also be connected to
>> other subsystems. That's something we need to figure out. But yes,
>> ultimately this should be the place where EDID is retrieved.
> 
> I already said this in another thread. I think we should only be using
> the CDF .get_modes() for static modes that cannot be obtained from EDID.
> Thinking about it, I'm not quite sure why EDID would be needed for this
> kind of panel anyway. Ventana probably has it because it keeps us from
> having to hardcode things, but if we provide drivers for the panel
> anyway, we can just as well hard-code the supported mode(s) in those
> drivers.

I don't think so. I think it's better that we only have one entry for
getting video modes. Since CDF already provides ".get_modes" for us, we
can rely on that. And according to my understanding, get video modes in
panel driver makes sense than getting it in crtc.

In this way, panel driver may get video modes from EDID or from
hard-coded display timing infos, but other modules such as crtc don't
need to care about that.

Mark
> 
> What I'm trying to say is that the existence of EDID is board-specific,
> so boards other than Ventana may not have an EDID EEPROM. Or perhaps
> this particular display has the EEPROM integrated? Even in that case,
> some boards may use this panel and simply not connect the EEPROM to an
> I2C controller.
> 
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 
