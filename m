Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3CHMup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:50:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:54247 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3CHMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:50:43 -0500
Date: Fri, 8 Mar 2013 13:50:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Emelyanov <xemul@parallels.com>
cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] posix timers: Allocate timer id per process (v2)
In-Reply-To: <512665E1.4040800@parallels.com>
Message-ID: <alpine.LFD.2.02.1303081349020.22263@ionos>
References: <512665BA.9040802@parallels.com> <512665E1.4040800@parallels.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Thu, 21 Feb 2013, Pavel Emelyanov wrote:

> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per process. Next free timer id is
> type of integer and stored on signal struct (posix_timer_id). If free timer
> id reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.
> 
> Hash table has 512 slots.
> Key is constructed as follows:
> key = hash_32(hash_32(current->signal) ^ posix_timer_id));
> 
> Note: with this patch, id, returned to user, is not the minimal free
> amymore. It means, that id, returned to user space in loop, listed below,
> will be increasing on each iteration till INT_MAX and then dropped to zero:
> 
> while(1) {
> 	id = timer_create(...);
> 	timer_delete(id);
> }
> 
> In this version the helpers from include/linux/hashtable.h are used
> instead of hand-made hash-table.

I think the patches are ready to go, though the changelog needs quite
some care.

It's explaining what the patch does and not why. Can you please
rework?

Thanks,

	tglx
