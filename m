Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaFSPDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:03:10 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:49613 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933188AbaFSPDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:03:08 -0400
Date: Thu, 19 Jun 2014 10:03:04 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
In-Reply-To: <53A2F406.4010109@oracle.com>
Message-ID: <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
References: <53A2F406.4010109@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Sasha Levin wrote:

> [  690.770137] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [  690.770137] __slab_alloc (mm/slub.c:1732 mm/slub.c:2205 mm/slub.c:2369)
> [  690.770137] ? __lock_acquire (kernel/locking/lockdep.c:3189)
> [  690.770137] ? __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> [  690.770137] kmem_cache_alloc (mm/slub.c:2442 mm/slub.c:2484 mm/slub.c:2489)
> [  690.770137] ? __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> [  690.770137] ? debug_object_activate (lib/debugobjects.c:439)
> [  690.770137] __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> [  690.770137] debug_object_init (lib/debugobjects.c:365)
> [  690.770137] rcuhead_fixup_activate (kernel/rcu/update.c:231)
> [  690.770137] debug_object_activate (lib/debugobjects.c:280 lib/debugobjects.c:439)
> [  690.770137] ? discard_slab (mm/slub.c:1486)
> [  690.770137] __call_rcu (kernel/rcu/rcu.h:76 (discriminator 2) kernel/rcu/tree.c:2585 (discriminator 2))

__call_rcu does a slab allocation? This means __call_rcu can no longer be
used in slab allocators? What happened?
