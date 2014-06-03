Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaFCVM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:12:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:59546 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaFCVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:12:56 -0400
Date: Tue, 3 Jun 2014 23:12:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
In-Reply-To: <20140603162514.7b11f3ea@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406032310560.3319@nanos>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603160524.7895f225@gandalf.local.home> <20140603200938.GA3384@redhat.com>
 <20140603162514.7b11f3ea@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jun 2014, Steven Rostedt wrote:

> On Tue, 3 Jun 2014 22:09:38 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>  
> > > Now, if that lock is released and reused (I didn't trace other tasks
> > > allocating these locks), it reinitializes the lock->wait_list.
> > 
> > How? From where? This should be done by sighand_ctor() only?
> 
> This looks definitely like an -rt only bug and it's an obvious one at
> that :-p
> 
> Looking in mm/slub.c: slab_alloc_node() we have this:
> 
>         if (unlikely(gfpflags & __GFP_ZERO) && object)
>                 memset(object, 0, s->object_size);
> #ifdef CONFIG_PREEMPT_RT_FULL
>         if (unlikely(s->ctor) && object)
>                 s->ctor(object);
> #endif  

Looks like the usual git/quilt default artifact.
 
That's why I have 

       QUILT_PATCH_OPTS="--fuzz=0"

in my .quiltrc 

Thanks,

	tglx
