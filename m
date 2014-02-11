Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbaBKIPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:15:33 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60659 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKIPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:15:32 -0500
Date: Tue, 11 Feb 2014 13:45:24 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/spufs: Remove MAX_USER_PRIO define
Message-ID: <20140211081524.GA8278@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1392098717.689604.970589769393.1.gpush@pablo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1392098717.689604.970589769393.1.gpush@pablo>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021108-2674-0000-0000-00000CA88E7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Kerr <jk@ozlabs.org> [2014-02-11 14:05:17]:

> Current ppc64_defconfig fails with:
> 
>  arch/powerpc/platforms/cell/spufs/sched.c:86:0: error: "MAX_USER_PRIO" redefined [-Werror]
>  cc1: all warnings being treated as errors
> 
> 6b6350f1 introduced a generic MAX_USER_PRIO macro to sched/prio.h, which
> is causing the conflit. Use that one instead of our own.

you can also use DEFAULT_PRIO from sched/prio.h instead of NORMAL_PRIO.

diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 49318385d4fa..014979db2018 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -64,11 +64,6 @@ static struct timer_list spusched_timer;
 static struct timer_list spuloadavg_timer;
 
 /*
- * Priority of a normal, non-rt, non-niced'd process (aka nice level 0).
- */
-#define NORMAL_PRIO		120
-
-/*
  * Frequency of the spu scheduler tick.  By default we do one SPU scheduler
  * tick for every 10 CPU scheduler ticks.
  */
@@ -97,7 +92,7 @@ static struct timer_list spuloadavg_timer;
  */
 void spu_set_timeslice(struct spu_context *ctx)
 {
-	if (ctx->prio < NORMAL_PRIO)
+	if (ctx->prio < DEFAULT_PRIO)
 		ctx->time_slice = SCALE_PRIO(DEF_SPU_TIMESLICE * 4, ctx->prio);
 	else
 		ctx->time_slice = SCALE_PRIO(DEF_SPU_TIMESLICE, ctx->prio);

Thanks,
Kamalesh.

