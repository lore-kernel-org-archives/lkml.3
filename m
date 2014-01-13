Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaAMQWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:22:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaAMQV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:21:59 -0500
Date: Mon, 13 Jan 2014 17:20:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] lockdep: Kill held_lock->check and "int check" arg
	of __lock_acquire()
Message-ID: <20140113162040.GB7616@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net> <20140112094041.GB31809@gmail.com> <20140112174532.GA12147@redhat.com> <20140112174554.GB12147@redhat.com> <20140113002811.GA24735@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113002811.GA24735@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Dave Jones wrote:
>
> On Sun, Jan 12, 2014 at 06:45:54PM +0100, Oleg Nesterov wrote:
>
>  > diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
>  > index 92b1bfc..13bd13d 100644
>  > --- a/include/linux/lockdep.h
>  > +++ b/include/linux/lockdep.h
>  > @@ -252,7 +252,6 @@ struct held_lock {
>  >  	unsigned int trylock:1;						/* 16 bits */
>  >
>  >  	unsigned int read:2;        /* see lock_acquire() comment */
>  > -	unsigned int check:2;       /* see lock_acquire() comment */
>  >  	unsigned int hardirqs_off:1;
>  >  	unsigned int references:11;					/* 32 bits */
>
> The 'bits' comments seem to be crap, even before your patch.

Hmm, I didn't even notice them.

I think the comments were correct, note that the previous field is uint:13.

But after (with) this patch the width of "references" should be updated.

Thanks,

Oleg.

