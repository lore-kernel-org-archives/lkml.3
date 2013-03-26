Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3CZLOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:14:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:55045 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3CZLOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:14:32 -0400
Date: Tue, 26 Mar 2013 12:14:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] irq: get_irq_disable_depth.
In-Reply-To: <1364251295-26358-1-git-send-email-andreas.fenkart@streamunlimited.com>
Message-ID: <alpine.LFD.2.02.1303261210230.22263@ionos>
References: <1364251295-26358-1-git-send-email-andreas.fenkart@streamunlimited.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Andreas Fenkart wrote:
> Used to verify invariant in omap_hsmmc, were a gpio is used to detect
> sdio irqs during suspend phase. The ref count from irq_enable/irq_disable
> is used to control when the irq should be effectively enabled.
> 
>                  irq en     irq dis
>             ------------------------
>   pm suspend  |    0     |   1
>   pm default  |    1     |   2
> 
>               irq disable depth
> 
> When the sdio irq is enabled AND the module is in runtime suspend,
> the ref must be zero so the irq is effectively enabled.
> 
> This function helps to verify, that the disable depth has the
> right value at different driver states.

I'm really not getting it. The SDIO driver knows whether it has
interrupts enabled or not, so what needs to be verified?

If you need this just to debug your driver, then please keep it in
your private tree. I really can't see a general value for this.

Thanks,

	tglx
