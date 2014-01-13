Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaAMA3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 19:29:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaAMA3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:29:02 -0500
Date: Sun, 12 Jan 2014 19:28:11 -0500
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] lockdep: Kill held_lock->check and "int check" arg
 of __lock_acquire()
Message-ID: <20140113002811.GA24735@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109163120.GA8038@redhat.com>
 <20140109170823.GF7572@laptop.programming.kicks-ass.net>
 <20140112094041.GB31809@gmail.com>
 <20140112174532.GA12147@redhat.com>
 <20140112174554.GB12147@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140112174554.GB12147@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 06:45:54PM +0100, Oleg Nesterov wrote:
 
 > diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
 > index 92b1bfc..13bd13d 100644
 > --- a/include/linux/lockdep.h
 > +++ b/include/linux/lockdep.h
 > @@ -252,7 +252,6 @@ struct held_lock {
 >  	unsigned int trylock:1;						/* 16 bits */
 >  
 >  	unsigned int read:2;        /* see lock_acquire() comment */
 > -	unsigned int check:2;       /* see lock_acquire() comment */
 >  	unsigned int hardirqs_off:1;
 >  	unsigned int references:11;					/* 32 bits */

The 'bits' comments seem to be crap, even before your patch.

	Dave

