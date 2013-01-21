Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3AUISQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:18:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2760 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3AUISO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:18:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Jan 2013 00:18:02 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>, "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 0/3] pwm-backlight: add subdrivers & Tegra support
Date: Mon, 21 Jan 2013 17:18:11 +0900
Message-ID: <6871054.sK10m5bePf@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.5 (Linux/3.6.11-1-ARCH; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130121074928.GE15508@avionic-0098.adnet.avionic-design.de>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <20130121074928.GE15508@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Monday 21 January 2013 15:49:28 Thierry Reding wrote:
> Eventually this should all be covered by the CDF, but since that's not
> ready yet we want something ad-hoc to get the hardware supported. As
> such I would like to see this go into some sort of minimalistic, Tegra-
> specific display/panel framework. I'd prefer to keep the pwm-backlight
> driver as simple and generic as possible, that is, a driver for a PWM-
> controlled backlight.
> 
> Another advantage of moving this into a sort of display framework is
> that it may help in defining the requirements for a CDF and that moving
> the code to the CDF should be easier once it is done.
> 
> Last but not least, abstracting away the panel allows other things such
> as physical dimensions and display modes to be properly encapsulated. I
> think that power-on/off timing requirements for panels also belong to
> this set since they are usually specific to a given panel.
> 
> Maybe adding these drivers to tegra-drm for now would be a good option.
> That way the corresponding glue can be added without a need for inter-
> tree dependencies.

IIRC (because that was a while ago already) having a Tegra-only display 
framework is exactly what we wanted to avoid in the first place. This series 
does nothing but leverage the callbacks mechanism that already exists in pwm-
backlight and make it available to DT systems. If we start making a Tegra-
specific solution, then other architectures will have to reinvent the wheel 
again. I really don't think we want to go that way.

These patches only makes slight changes to pwm_bl.c and do not extend its 
capabilities. I agree that a suitable solution will require the CDF, but by 
the meantime, let's go for the practical route instead of repeating the same 
mistakes (i.e. architecture-specific frameworks) again.

There are certainly better ways to do this, but I'm not convinced at all that 
a Tegra-only solution is one of them.

Alex.

