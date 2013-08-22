Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3HVSxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:53:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3HVSxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:53:16 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F0my4ousGMIA:10 a=Tp7CHUPqXj_OpLDQFjYA:9 a=CjuIK1q_8ugA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 22 Aug 2013 14:53:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.9-rt5
Message-ID: <20130822145314.32bdb0f9@gandalf.local.home>
In-Reply-To: <20130822182127.GA7606@linutronix.de>
References: <20130822182127.GA7606@linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013 20:21:27 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> Known issues:
> 
>       - SLAB support not working
> 
>       - The cpsw network driver shows some issues.
> 
>       - bcache does not compile.

For now, it may be prudent to just make bcache depend on !PREEMPT_RT.

I can send a patch if you want.

-- Steve

> 
>       - set_affinity callbacks result in splat due to sleeping while
>         atomic
> 
>       - an ancient race (since we got sleeping spinlocks) where the
>         TASK_TRACED state is temporary replaced while waiting on a rw
>         lock and the task can't be traced.
> 
