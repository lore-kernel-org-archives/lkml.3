Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3HHF3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:29:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3HHF3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:29:16 -0400
Message-ID: <1375939750.18565.11.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: "ethan.zhao" <ethan.kernel@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>,
        Youquan Song <youquan.song@intel.com>, LenBrown <len.brown@intel.com>
Date: Thu, 08 Aug 2013 07:29:10 +0200
In-Reply-To: <BD6ACAD8-25D7-406B-A843-22696F9D8DCC@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
	 <20130730093519.GP3008@twins.programming.kicks-ass.net>
	 <1375774140.5412.9.camel@marge.simpson.net>
	 <1375775172.5412.14.camel@marge.simpson.net>
	 <BD6ACAD8-25D7-406B-A843-22696F9D8DCC@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:+a3m22LJ8Kb/rNqN+O7qiOLavcRYR++CQo/UPy3B4eO
 i5r5t3zDB6PCvmd+bcQZGspL6rHsgRQEj6g0EHwQU1miuUhfGP
 6m40irUC55ilOp340qZfPLejL9MMHtv9Qd7Ql15xrKmGJeHNqx
 lk3bv5MZxLYdRKcutxd4aCyM7qNMDM+a0+EXwmhVP4tQ7d8JYC
 cf+YlFmEM8JXCiNt4frqtJw6w9BZ40i/ccRgCv0Voo0nry/m+Z
 gbAaL0SAn3xGVk1gdWxaCFowVqoy0syFz17I21xErVeFGd38ai
 TOd0nZ7jXZGcIvhm4GScghIHlVG8e1XZXqgqj2CVHkykMTBWJZ
 FW6F37zicVXhfZkStZVQMen8NclkbZcqaYfYyz1qJacHinP8eV
 fHQjbJYLlYQWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I got several copies of that, one would have been plenty.  Some people
get all grumpy when they get repeats, and at least one, who shall remain
unnamed, gets even grumpier when folks don't trim their replies, so be
careful;)

On Thu, 2013-08-08 at 12:31 +0800, ethan.zhao wrote:

> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 4137890..c27f04f 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -137,7 +137,7 @@ static inline void play_dead(void)
> 
> static inline void smp_send_reschedule(int cpu)
> {
> -       smp_ops.smp_send_reschedule(cpu);
> +       /* smp_ops.smp_send_reschedule(cpu); */
> }

Hm.  You're much braver than I am.

-Mike

