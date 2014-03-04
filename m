Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaCDXTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:19:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:51213 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbaCDXTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:19:31 -0500
Message-ID: <1393975112.10727.103.camel@pasglop>
Subject: Re: [tip:irq/core] powerpc: eeh: Fixup the brown paperbag fallout
 of the "cleanup"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        peterz@infradead.org, linuxppc-dev@lists.ozlabs.org,
        tglx@linutronix.de, shangw@linux.vnet.ibm.com
Cc: linux-tip-commits@vger.kernel.org
Date: Wed, 05 Mar 2014 10:18:32 +1100
In-Reply-To: <tip-57310c3c99eb6fab2ecbd63aa3f7c323341ca77e@git.kernel.org>
References: <tip-57310c3c99eb6fab2ecbd63aa3f7c323341ca77e@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 15:15 -0800, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  57310c3c99eb6fab2ecbd63aa3f7c323341ca77e
> Gitweb:     http://git.kernel.org/tip/57310c3c99eb6fab2ecbd63aa3f7c323341ca77e
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Wed, 5 Mar 2014 00:06:11 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 5 Mar 2014 00:13:33 +0100
> 
> powerpc: eeh: Fixup the brown paperbag fallout of the "cleanup"
> 
> Commit b8a9a11b9 (powerpc: eeh: Kill another abuse of irq_desc) is
> missing some brackets .....
> 
> It's not a good idea to write patches in grumpy mode and then forget
> to at least compile test them or rely on the few eyeballs discussing
> that patch to spot it.....

Ouch :-)

Next time you have a series like that, if you want I'll throw it at my
build tester.

Cheers,
Ben.

> Reported-by: fengguang.wu@intel.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: ppc <linuxppc-dev@lists.ozlabs.org>
> ---
>  arch/powerpc/kernel/eeh_driver.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
> index 3e1d7de..bb61ca5 100644
> --- a/arch/powerpc/kernel/eeh_driver.c
> +++ b/arch/powerpc/kernel/eeh_driver.c
> @@ -166,8 +166,9 @@ static void eeh_enable_irq(struct pci_dev *dev)
>  		 *
>  		 *	tglx
>  		 */
> -		if (irqd_irq_disabled(irq_get_irq_data(dev->irq))
> +		if (irqd_irq_disabled(irq_get_irq_data(dev->irq)))
>  			enable_irq(dev->irq);
> +	}
>  }
>  
>  /**


