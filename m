Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaKIE4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 23:56:08 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63070 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaKIE4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 23:56:06 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18VM1ohISmQxuGl6dlOcZW7JR5CMXBqRB8=
X-DKIM: OpenDKIM Filter v2.0.1 titan BF712615671
Date: Sat, 8 Nov 2014 23:55:50 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] irqchip: atmel-aic: add RTT irq fixup
Message-ID: <20141109045550.GS3698@titan.lakedaemon.net>
References: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 09:30:59AM +0100, Boris Brezillon wrote:
> Hello,
> 
> This patch series add a new fixup function for the RTT (Real Time Timer)
> block and make use of it on SoCs integrating at least one RTT to prevent
> spurious interrupts on the first interrupt line.
> 
> This fixup function was previously implemented in
> arch/arm/mach-at91/sysirq_mask.c, but is now moved to the AIC driver so
> that we can remove SoC specific hooks in arch/arm/mach-at91/ when booting
> a DT kernel.
> 
> This series also reworks the naming convention of the SoC specific fixup
> functions and add an entry for the at91rm9200.
> 
> Best Regards,
> 
> Boris
> 
> Changes since v1:
> - rebased on linux-3.18-rc2
> 
> Boris BREZILLON (5):
>   irqchip: atmel-aic: add irq fixup for RTT block
>   irqchip: atmel-aic: add irq fixups for at91sam926x SoCs
>   irqchip: atmel-aic: add specific irq fixup function for sam9g45 and
>     sam9rl
>   irqchip: atmel-aic: rename at91sam9_aic_irq_fixup for naming
>     consistency
>   irqchip: atmel-aic: add missing entry for rm9200 irq fixups
> 
>  drivers/irqchip/irq-atmel-aic-common.c | 26 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-atmel-aic-common.h |  2 ++
>  drivers/irqchip/irq-atmel-aic.c        | 26 +++++++++++++++++++++-----
>  3 files changed, 49 insertions(+), 5 deletions(-)

Whole series applied to irqchip/atmel

thx,

Jason.
