Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbaELOJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:09:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:61457 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758472AbaELOJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:09:11 -0400
Date: Mon, 12 May 2014 10:09:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dongsheng Yang <dongsheng081251@gmail.com>,
        "yangds.fnst" <yangds.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bsegall@google.com
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
Message-ID: <20140512100908.07cc50bc@gandalf.local.home>
In-Reply-To: <20140512064730.GI30445@twins.programming.kicks-ass.net>
References: <53683B14.3060702@cn.fujitsu.com>
	<1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140510152902.GW11096@twins.programming.kicks-ass.net>
	<536F90BE.2080806@gmail.com>
	<CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
	<20140511163531.GG30445@twins.programming.kicks-ass.net>
	<20140511145224.00412e59@gandalf.local.home>
	<20140512064730.GI30445@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 08:47:30 +0200
Peter Zijlstra <peterz@infradead.org> wrote:


> But that has nothing what so fucking ever to do with 'success'. Reusing
> that trace argument for something entirely different is just retarded.

And having a "success" field that his hard coded to "true" is also
retarded. At least this change is fucking useful.

How about this. Add a new field called 'rq_added' or something. We can
ever shrink the size of the "success" field and hard code it to true in
the trace. That will never change. Then the caller of the tracepoint
will send in a "true" or "false" to "rq_added" and we can add that
tracepoint as well.

What I mean by shrink the size of the success field is that it is
currently 4 bytes in size. We can make it two (or one) and then add
another field for the 'rq_added' and have that be two bytes as well.
This shouldn't break any tools that use this.

Point being, this is useful information, why not pass it to userspace?

-- Steve

