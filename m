Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaGGNqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:46:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaGGNpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:45:34 -0400
Date: Mon, 7 Jul 2014 15:45:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net, paulus@samba.org,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/workqueue: lockdep warning on process exit
Message-ID: <20140707134521.GQ6758@twins.programming.kicks-ass.net>
References: <539EFE3A.7020700@oracle.com>
 <20140623141242.GB19860@laptop.programming.kicks-ass.net>
 <53AB3C7C.5040605@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y23ShSVTng6i3e6h"
Content-Disposition: inline
In-Reply-To: <53AB3C7C.5040605@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y23ShSVTng6i3e6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 25, 2014 at 05:17:48PM -0400, Sasha Levin wrote:
> [ 1853.817250] 2 locks held by trinity-c3/29876:
> [ 1853.817250]  #0: cpu_hotplug.lock){++++++}, at: get_online_cpus (kernel/cpu.c:90)
> [ 1853.924037]  #1: (&ctx->lock){-.-...}, at: perf_lock_task_context (kernel/events/core.c:983)
> [ 1853.924037]


> [ 1853.924037] Call Trace:

> [ 1853.924037] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> [ 1853.924037] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> [ 1853.924037] __queue_work (kernel/workqueue.c:1339)
> [ 1853.924037] queue_work_on (kernel/workqueue.c:1417)
> [ 1853.924037] free_object (lib/debugobjects.c:209)
> [ 1853.924037] __debug_check_no_obj_freed (lib/debugobjects.c:715)
> [ 1853.924037] debug_check_no_obj_freed (lib/debugobjects.c:727)
> [ 1853.924037] kmem_cache_free (mm/slub.c:2657 mm/slub.c:2686)
> [ 1853.924037] free_task (kernel/fork.c:221)
> [ 1853.924037] __put_task_struct (kernel/fork.c:250)
> [ 1853.924037] put_ctx (include/linux/sched.h:1857 kernel/events/core.c:899)
> [ 1853.924037] find_get_context (kernel/events/core.c:908 kernel/events/core.c:3161)
> [ 1853.924037] SYSC_perf_event_open (kernel/events/core.c:7200)
> [ 1853.924037] ? preempt_count_sub (kernel/sched/core.c:2606)
> [ 1853.924037] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
> [ 1853.924037] SyS_perf_event_open (kernel/events/core.c:7064)

Egads.. that shouldn't be possible.

The only put_ctx() from find_get_context() is in the !ctx branch, and if
perf_lock_task_context() returns NULL it shouldn't be holding ctx->lock.

Does this reproduce?

--y23ShSVTng6i3e6h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTuqRxAAoJEHZH4aRLwOS6gkgQAKqv6+pT0JgYkzpPgeN+Fhgm
PCQ3AcbGmQ54yf3oQVoZbQ5wmgUUOlEdtYxCGldG9nK4imQX//bCjX7mc3Qhj0NS
1yrdu4zNcQecUtzJxLUxhWic5NtWnuLhzx4he6iIU6sGX8AtzyG5GczgNbP2C271
dlT9GeelMxIYdq8MOQCy782O1q5+yr4+8RsArzB8abyS97q8X7a5BFcyjOuwZw5J
h+6M+B3CXzRgIoH1W0KPKBLhwEAqHrRDJWEXzpEQRj1XBMSN6JXYj1InXqeCMon4
6Whp1xSxlqIGfA/jz0PK83mvonMmo2xmXadlVA1p15W+0JpcsUMwiUiBXQ64CLjk
F6tHjbtku0H3kLAA6fGVrVe6sAOoAa8QxO0iCMmUFLQZwsQcTTexLCKoTuzABFSp
6bhshD1ud6RQZcA+jxJUiHTZh83ojsIUIVFbSe42m7k8VkfXHu9+nQe0+Qttcsjd
xQ2cuqA+kplyL16Z+5oxBMO4YTUWtzP4dHLKxEpyZB7qtp4yTO6qs3cKf1UsoA+0
sAd2VacWkFeTfCrq2exK21zwu8Rn+49VQ5j7NEgtMZo/L9/nZht31t7linrvLX8L
qcGoh3qmb5xGKiPTfspk3fql+nSIwvuIlG9xTYS+Up92/vVaJvgbsmvi2FbJqJCa
vLJpRkA+SaZd4HfnbhKn
=IWrY
-----END PGP SIGNATURE-----

--y23ShSVTng6i3e6h--
