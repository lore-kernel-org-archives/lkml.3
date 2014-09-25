Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaIYV5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:57:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33252 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751595AbaIYV5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:57:34 -0400
Date: Thu, 25 Sep 2014 18:56:12 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: tglx@linutronix.de, jason@lakedaemon.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, alior@marvell.com,
        tawfik@marvell.com, mw@semihalf.com,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Subject: Re: [PATCH 0/2] Marvell Armada 375/38x MPIC/MSI fixes
Message-ID: <20140925215612.GA3846@arch.cereza>
References: <1411643839-64925-1-git-send-email-jaz@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411643839-64925-1-git-send-email-jaz@semihalf.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

On 25 Sep 01:17 PM, Grzegorz Jaszczyk wrote:
> This patchset contains a set of fixes for issues found while doing some test
> with different interrupts configuration on Armada 375 and Armada 38x Marvell
> SoCs. The patches were tested and apply on v3.17-rc6.
> 
> Any feedback is welcome.
> 
> Grzegorz Jaszczyk (2):
>   irqchip: armada-370-xp: fix MSI interrupt handling
>   irqchip: armada-370-xp: fix MPIC interrupt handling

The second patch fixes an unhandled IRQ storm triggered by the mvpp2
ethernet driver, when the kernel is built with CONFIG_SMP=n.

When any network activity is attempted the kernel is interrupted by a per-cpu 
IRQ (which is not the one the driver expects). The interrupt is not mapped 
into Linux's virtual IRQ space, so the result is:

  irq 0, desc: ee004000, depth: 1, count: 0, unhandled: 0
  ->handle_irq():  c00466e8, handle_bad_irq+0x0/0x260
  ->irq_data.chip(): c1181460, 0xc1181460
  ->action():   (null)
     IRQ_NOPROBE set
   IRQ_NOREQUEST set

For both patches:

Fixes: bc69b8adfe22 ("irqchip: armada-370-xp: Setup a chained handler for the MPIC")
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Thanks,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
