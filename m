Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3GBM2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:28:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:60296 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3GBM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:28:49 -0400
Date: Tue, 2 Jul 2013 14:28:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] metag: kick: add missing irq_enter/exit to
 kick_handler()
In-Reply-To: <1372759013-29911-1-git-send-email-james.hogan@imgtec.com>
Message-ID: <alpine.DEB.2.02.1307021428370.4013@ionos.tec.linutronix.de>
References: <1372759013-29911-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013, James Hogan wrote:

> kick_handler() doesn't have an irq_enter/exit pair, but it's used for
> handling SMP IPIs which require work to be done in softirqs, which are
> invoked from irq_exit() when the hard irq nest count reaches 0.
> 
> The scheduler_ipi() callback in the IPI handler calls irq_enter/exit
> itself, but this is inside kick_handler()'s spin lock critical section,
> so if an invoked softirq issues an IPI the kick_handler() will be
> re-entered on the same CPU and will deadlock.
> 
> This is easily fixed by adding the missing irq_enter/exit to
> kick_handler() so that the hard irq nest count doesn't reach 0 until
> after the spin lock has been released.
> 
> Ideally the spin lock protected handler list will also be replaced by a
> lockless RCU protected list since it is certainly mostly read. That can
> be done in a later change though.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
