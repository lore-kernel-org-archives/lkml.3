Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaBNNRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:17:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:41655 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaBNNRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:17:06 -0500
Date: Fri, 14 Feb 2014 14:17:05 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: [PATCH RT 4/5] allow preemption in
 mem_cgroup_move_account_page_stat
Message-ID: <20140214131705.GF28438@linutronix.de>
References: <20140210153933.GE20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140210153933.GE20017@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-02-10 16:39:33 [+0100]:

>index a67e630f..e7cc35a 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -3784,10 +3784,10 @@ void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
> 					enum mem_cgroup_stat_index idx)
> {
> 	/* Update stat data for mem_cgroup */
>-	preempt_disable();
>+	migrate_disable();
> 	__this_cpu_sub(from->stat->count[idx], nr_pages);
> 	__this_cpu_add(to->stat->count[idx], nr_pages);
>-	preempt_enable();
>+	migrate_enable();
> }

Now, that I look at it again. Isn't it more efficient to keep preemption
disabled for this very short time instead instead of invoking
migrate_disable() which includes preempt_disable()/enable() and a few
more opcodes…
Therefore, I drop it again.

Sebastian
