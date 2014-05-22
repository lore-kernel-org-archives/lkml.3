Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaEVWU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:20:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:54106 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEVWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:20:56 -0400
Date: Fri, 23 May 2014 07:21:02 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: amirv@mellanox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bhutchings@solarflare.com, yevgenyp@mellanox.com,
        ogerlitz@mellanox.com, eyalpe@mellanox.com
Subject: Re: [PATCH net-next] genirq: Eliminate explicit dependency between
 IRQ affinity notifiers and CONFIG_SMP
In-Reply-To: <20140522.152808.802269502342645717.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1405230717310.8522@ionos.tec.linutronix.de>
References: <1400597820-30685-1-git-send-email-amirv@mellanox.com> <20140522.152808.802269502342645717.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, David Miller wrote:

> From: Amir Vadai <amirv@mellanox.com>
> Date: Tue, 20 May 2014 17:57:00 +0300
> 
> > From: Eyal Perry <eyalpe@mellanox.com>
> > 
> > Instead of requiring each consumer of the IRQ affinity notifier to have
> > themselves be explicitly dependent on CONFIG_SMP, make the definition of
> > struct irq_affinity_notify to exist independently of that config option
> > and introduce a stub for irq_set_affinity_notifier() under non SMP
> > configuration.
> > 
> > Fixes: 2eacc23 ("net/mlx4_core: Enforce irq affinity changes
> > immediatly")
> > 
> > Signed-off-by: Eyal Perry <eyalpe@mellanox.com>
> > Signed-off-by: Amir Vadai <amirv@mellanox.com>
> 
> IRQ layer folks please review and push upstream if there aren't any
> problems.

It's queued for 3.16 in irq/core and also available for you as a
single commit to merge into your next tree at:

 git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/for-net

if you want to carry it along for testing.

Thanks,

	tglx
