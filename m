Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3GAVvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:51:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:57380 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab3GAVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:51:13 -0400
Date: Mon, 1 Jul 2013 23:51:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] metag: kick: prevent nested kick handlers
In-Reply-To: <1372694659-30176-5-git-send-email-james.hogan@imgtec.com>
Message-ID: <alpine.DEB.2.02.1307012346320.4013@ionos.tec.linutronix.de>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-5-git-send-email-james.hogan@imgtec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, James Hogan wrote:

> The main kick trigger handler iterates a list of kick handlers and calls
> each one. This is done with the kick_handlers_lock spin lock held, but
> this causes a problem on SMP where IPIs are implemented with kicks. A
> reschedule IPI calls scheduler_ipi() which uses irq_enter() and
> irq_exit(). This results in the scheduler being invoked with
> kick_handlers_lock held which can result in a nested kick trigger
> attempting to acquire the lock, resulting in deadlock.
> 
> irq_enter() and irq_exit() can nest, so call them from the main kick
> interrupt handler so that softirqs are only handled after
> kick_handlers_lock is released.

This changelog is confusing. What I decode from the patch is, that you
are adding a missing irq_enter/exit pair to the kick_handler, right ?

Thanks,

	tglx
