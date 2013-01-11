Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3AKOet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:34:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:51463 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3AKOes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:34:48 -0500
Date: Fri, 11 Jan 2013 15:34:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michel Lespinasse <walken@google.com>
cc: David Howells <dhowells@redhat.com>, Salman Qazi <sqazi@google.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwlock_t unfairness and tasklist_lock
In-Reply-To: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1301111522150.7475@ionos>
References: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2013, Michel Lespinasse wrote:
> - Does anyone know of any current work towards removing the
> tasklist_lock use of rwlock_t ? Thomas Gleixner mentioned 3 years ago
> that he'd give it a shot (https://lwn.net/Articles/364601/), did he
> encounter some unforeseen difficulty that we should learn from ?

I converted quite a bunch of the read side instances to rcu
protection, but got distracted. There was no fundamental difficulty,
just lack of time.
 
> - Would there be any fundamental objection to implementing a fair
> rwlock_t and dealing with the reentrancy issues in tasklist_lock ? My
> proposal there would be along the lines of:
> 
> 1- implement a fair rwlock_t - the ticket based idea from David
> Howells seems quite appropriate to me

Nah. Lets get it killed. Most of the stuff can be converted to RCU and
the remaining bits and pieces are the write lock sides which then can
be converted to a big standard spinlock. There might be a few more
complex ones, but Oleg said back then that those should be solved by
locking the process instead of locking the whole tasklist.

Thanks,

	tglx


