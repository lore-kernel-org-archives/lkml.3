Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3A3H1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:27:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19912 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3A3H1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:27:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jan 2013 23:26:56 -0800
Message-ID: <5108CB4F.7000103@nvidia.com>
Date: Wed, 30 Jan 2013 16:27:11 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <5108C9C1.1090707@gmail.com>
In-Reply-To: <5108C9C1.1090707@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 04:20 PM, Mark Zhang wrote:
>> +	/* OFF and STANDBY are equivalent to us */
>> +	if (state == DISPLAY_ENTITY_STATE_STANDBY)
>> +		state = DISPLAY_ENTITY_STATE_OFF;
>
> Do we need this? The "switch" below handles the same thing already.

Indeed, I have rewritten this part actually.

>> +static int panel_claa101_get_modes(struct display_entity *entity,
>> +				   const struct videomode **modes)
>> +{
>> +	/* TODO get modes from EDID? */
>
> Why not move the "nvidia,ddc" from encoder's DT to panel's DT? In that
> case, you can get EDID here. I know drm has some helpers to fetch EDID
> but I recall there are some other functions which has no drm
> dependencies which may be suitable for you.

I explained this in the cover letter - I'm not sure we want to have a 
dependency on DRM here, as CDF entities could also be connected to other 
subsystems. That's something we need to figure out. But yes, ultimately 
this should be the place where EDID is retrieved.

>> +static struct of_device_id panel_claa101_of_match[] = {
>> +	{ .compatible = "chunghwa,claa101wa01a", },
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(of, pwm_backlight_of_match);
>
> What does this mean? Why we need this?

Well, now you know where I copy my code from. :)


Thanks,
Alex.

