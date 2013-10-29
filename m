Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab3J2RQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:16:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45621 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3J2RQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:16:46 -0400
Subject: Re: [PATCH v3 2/4] mmc: omap_hsmmc: Enable SDIO IRQ.
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1380971830-21492-3-git-send-email-afenkart@gmail.com>
Date: Tue, 29 Oct 2013 12:16:44 -0500
Cc: Chris Ball <cjb@laptop.org>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Venkatraman S <svenkatr@ti.com>, Balaji T K <balajitk@ti.com>,
        zonque@gmail.com, devicetree-discuss@lists.ozlabs.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EA1946E5-E119-4D4D-B99F-E96878DEC049@codeaurora.org>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com> <1380971830-21492-3-git-send-email-afenkart@gmail.com>
To: Andreas Fenkart <afenkart@gmail.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5, 2013, at 6:17 AM, Andreas Fenkart wrote:

> For now, only support SDIO interrupt if we are booted with
> DT. This is because some platforms need special quirks. And
> we don't want to add new legacy mux platform init code
> callbacks any longer as we are moving to DT based booting
> anyways.
> 
> Broken hardware, missing the swakueup line, should fallback
> to polling, by setting 'ti,quirk-swakup-missing' in the
> device tree. Otherwise pending SDIO IRQ are not detected
> while in suspend. This affects am33xx processors.
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> 
> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> index ed271fc..1136e6b 100644
> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> @@ -20,6 +20,24 @@ ti,dual-volt: boolean, supports dual voltage cards
> ti,non-removable: non-removable slot (like eMMC)
> ti,needs-special-reset: Requires a special softreset sequence
> ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
> +ti,quirk-swakup-missing: SOC missing the swakeup line, will not detect
> +SDIO irq while in suspend. Fallback to polling. Affected chips are
> +am335x,
> +
> +                            ------
> +                            | PRCM |
> +                             ------
> +                              ^ |
> +                      swakeup | | fclk
> +                              | v
> +      ------                -------               -----
> +     | card | -- CIRQ -->  | hsmmc | -- IRQ -->  | CPU |
> +      ------                -------               -----
> +
> +In suspend the fclk is off and the module is disfunctional. Even
> +register reads will fail. A small logic in the host will request fclk
> +restore, when an external event is detected. Once the clock is
> +restored, the host detects the event normally.
> 
> Example:
> 	mmc1: mmc@0x4809c000 {

For the DT-Binding portion:

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

