Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaDRKOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:14:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39941 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751110AbaDRKOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:14:16 -0400
Date: Fri, 18 Apr 2014 11:13:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 0/8] Reorder i.MX IPU display enable/disable sequence
Message-ID: <20140418101330.GC24070@n2100.arm.linux.org.uk>
References: <1397512403-19622-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397512403-19622-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:53:15PM +0200, Philipp Zabel wrote:
> Repeatedly enabling and disabling the display currently can lead to a state
> in which the IPU doesn't produce a valid signal anymore because we disable
> IPU submodules before they can finish their interaction.
> 
> This series reorders the enable/disable sequence so that we first wait for the
> DC/DP to finish processing the current frame, then stop the DI and IDMAC, and
> only then disable clocks to the submodules. Also from now on we really disable
> the DC when it is not in use.

Okay, I'm going to queue these up in a couple of days, but there's
something which I'd prefer to be fixed... there's one in particular
that is excessively long.

> Philipp Zabel (8):
>   imx-drm: ipu-common: add ipu_map_irq to request non-IDMAC interrupts
>   imx-drm: ipu-common: Add helpers to check for a busy IDMAC channel and
>     to busywait for an interrupt
>   imx-drm: ipu-dmfc: Wait for FIFOs to run empty before disabling
>   imx-drm: ipu-dc: Wait for DC_FC_1 / DP_SF_END interrupt
>   imx-drm: ipu-dp: Split disabling the DP foreground channel from
>     disabling the DP module
>   imx-drm: imx-dp: When disabling the DP foreground channel, wait until
>     the DP background channel is finished before disabling the IDMAC
>     channel

    imx-drm: imx-dp: disable DP fg channel after DP bg channel has finished

maybe?

>   imx-drm: ipuv3-crtc: Change display enable/disable order
>   imx-drm: ipu-dc: Disable DC module when not in use


-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
