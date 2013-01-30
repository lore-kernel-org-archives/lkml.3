Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3A3I2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:28:51 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7010 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3A3I2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:28:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 30 Jan 2013 00:28:27 -0800
Message-ID: <5108D9BA.9040305@nvidia.com>
Date: Wed, 30 Jan 2013 17:28:42 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Mark Zhang <nvmarkzhang@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <5108C9C1.1090707@gmail.com> <5108CB4F.7000103@nvidia.com> <20130130074852.GB17547@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130130074852.GB17547@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 04:48 PM, Thierry Reding wrote:
> I already said this in another thread. I think we should only be using
> the CDF .get_modes() for static modes that cannot be obtained from EDID.
> Thinking about it, I'm not quite sure why EDID would be needed for this
> kind of panel anyway. Ventana probably has it because it keeps us from
> having to hardcode things, but if we provide drivers for the panel
> anyway, we can just as well hard-code the supported mode(s) in those
> drivers.
>
> What I'm trying to say is that the existence of EDID is board-specific,
> so boards other than Ventana may not have an EDID EEPROM. Or perhaps
> this particular display has the EEPROM integrated? Even in that case,
> some boards may use this panel and simply not connect the EEPROM to an
> I2C controller.

Actually this display has its own EEPROM and pins for the I2C bus. 
That's why it would seems out-of-place to have EDID taking place outside 
its driver.

But you are right that we should also handle the case where the I2C bus 
is not connected and provide a static list of videomodes (that could be 
an "offline" dump of the EDID data). However, the driver could take the 
decision to use it if the EDID bus is not specified in the DT or if 
transfer failed for some reason.

But then as you mention we might as well save time and directly serve 
that offline version, since we know the content of the EEPROM anyway.

Alex.

