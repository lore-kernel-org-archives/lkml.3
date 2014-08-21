Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaHUMqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:46:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45089 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754291AbaHUMqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:46:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19xjwuTiLyFLEm0YH1zv8d95jaLv/aUS7M=
X-DKIM: OpenDKIM Filter v2.0.1 titan 439B35CB856
Date: Thu, 21 Aug 2014 08:45:50 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: renesas-intc-irqpin: Add suspend-to-RAM wake
 up support
Message-ID: <20140821124550.GX12769@titan.lakedaemon.net>
References: <1408546172-22484-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408546172-22484-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert,

On Wed, Aug 20, 2014 at 04:49:32PM +0200, Geert Uytterhoeven wrote:
> Set the ->irq_enable() and ->irq_disable() methods to NULL to enable
> lazy disable of interrupts, and set IRQCHIP_MASK_ON_SUSPEND to tell the
> core that only IRQs marked as wake-ups need to stay enabled during
> suspend-to-RAM.
> 
> This makes wake-up by gpio-keys from suspend-to-RAM work on
> r8a7740/Armadillo.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Not tested on sh73a0/kzm9g, r8a7778/bock-w, r8a7779/marzen
> 
> Similar changes for gpio-rcar and renesas-irqc went in before, but
> split in two parts:
>   - commit 272012d0f748de2e ("irqchip: renesas-irqc: Use lazy disable")
>   - commit 6a7e3b3007b5396a ("irqchip: renesas-irqc: Enable mask on suspend")
>   - commit fba968a1e6b84be0 ("gpio: rcar: Use lazy disable")
>   - commit 403961120667bed7 ("gpio: rcar: Enable mask on suspend")
> 
> However, I believe it doesn't make much sense to split this:
>   - Enabling lazy disable on its own introduces a regression, as it
>     causes the system to wake-up on IRQs not marked as wake-ups,
>   - Adding IRQCHIP_MASK_ON_SUSPEND on its own doesn't have any impact.
> ---
>  drivers/irqchip/irq-renesas-intc-irqpin.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied to irqchip/core

thx,

Jason.
