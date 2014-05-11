Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbaEKSw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 14:52:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:44101 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755373AbaEKSw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 14:52:28 -0400
Date: Sun, 11 May 2014 14:52:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dongsheng Yang <dongsheng081251@gmail.com>,
        "yangds.fnst" <yangds.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bsegall@google.com
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
Message-ID: <20140511145224.00412e59@gandalf.local.home>
In-Reply-To: <20140511163531.GG30445@twins.programming.kicks-ass.net>
References: <53683B14.3060702@cn.fujitsu.com>
	<1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140510152902.GW11096@twins.programming.kicks-ass.net>
	<536F90BE.2080806@gmail.com>
	<CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
	<20140511163531.GG30445@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2014 18:35:31 +0200
Peter Zijlstra <peterz@infradead.org> wrote:


> So if the wait side has already observed cond==false, then without the
> wakeup, which still potentially has ->on_rq == true, it would block.
> Therefore the wakeup is a _real_ wakeup.
> 
> We fundamentally cannot know, on the wake side, if the wait side has or
> has not observed cond, and therefore the distinction you're trying to
> make is a false one.

I believe you may be misunderstanding Dongsheng. It has nothing to do
with the wake condition. But the "success" is basically saying, "did I
move the task on to the run queue?". That's a relevant piece of
information that the wake up event isn't currently showing.

Let me ask you this; with Donsheng's patch, will there ever be a
sched_switch event when the wakeup event sees 'false' and the
sched_switch event see the task with a state other than "R"? And if so,
how did the task doing the wakeup event, wake up that task?

-- Steve
