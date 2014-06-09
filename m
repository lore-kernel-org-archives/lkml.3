Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaFISaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:30:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:49306 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbaFIS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:29:59 -0400
Date: Mon, 9 Jun 2014 14:29:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140609142956.3d79e9d1@gandalf.local.home>
In-Reply-To: <20140609181553.GA13681@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home>
	<20140603172632.GA27956@redhat.com>
	<CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
	<20140603200125.GB1105@redhat.com>
	<20140606203350.GU4581@linux.vnet.ibm.com>
	<20140608130718.GA11129@redhat.com>
	<20140609162613.GE4581@linux.vnet.ibm.com>
	<20140609181553.GA13681@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014 20:15:53 +0200
Oleg Nesterov <oleg@redhat.com> wrote:


> > That would indeed be a bad thing, as it could potentially lead to
> > use-after-free bugs.  Though one could argue that any code that resulted
> > in use-after-free would be quite aggressive.  But still...
> 
> And once again, note that the normal mutex is already unsafe (unless I missed
> something).

Is it unsafe?

This thread was started because of a bug we triggered in -rt, which
ended up being a change specific to -rt that modified the way slub
handled SLAB_DESTROY_BY_RCU. What else was wrong with it?

-- Steve
