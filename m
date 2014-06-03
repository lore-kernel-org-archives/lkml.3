Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064AbaFCUPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:15:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:29455 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932917AbaFCUPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:15:19 -0400
Date: Tue, 3 Jun 2014 16:15:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603161517.7e4ca4a8@gandalf.local.home>
In-Reply-To: <20140603200938.GA3384@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home>
	<20140603172632.GA27956@redhat.com>
	<CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
	<20140603160524.7895f225@gandalf.local.home>
	<20140603200938.GA3384@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 22:09:38 +0200
Oleg Nesterov <oleg@redhat.com> wrote:


> > Now, if that lock is released and reused (I didn't trace other tasks
> > allocating these locks), it reinitializes the lock->wait_list.
> 
> How? From where? This should be done by sighand_ctor() only?

heh, the more I look at this code, the deeper in the rabbit hole I go.

OK, I didn't understand this in the first place. I see that
sighand_ctor() is only called when the entire slab is created, correct?

That means, when you allocate a new sighand, it doesn't get
re-initialized, and the sighand->lock should still be the old lock.

That makes sense. I'll need to look at this some more :-/  Maybe
there's another bug that I'm missing and I'm climbing the wrong tree.

-- Steve
