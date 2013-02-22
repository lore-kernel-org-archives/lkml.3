Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3BVPHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:07:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:58168 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab3BVPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:07:00 -0500
Date: Fri, 22 Feb 2013 16:06:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in
 irq_exit()
In-Reply-To: <20130222150444.GD18149@somewhere.redhat.com>
Message-ID: <alpine.LFD.2.02.1302221605520.22263@ionos>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com> <1361496971-16939-3-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.02.1302221528470.22263@ionos> <20130222150444.GD18149@somewhere.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Frederic Weisbecker wrote:
> On Fri, Feb 22, 2013 at 03:33:51PM +0100, Thomas Gleixner wrote:
> > The minimal extra check at the end of irq_exit() is way better than
> > any other special cased workaround and the softirq stuff is really the
> > only thing which needs to be taken care of. Anything else just works.
> 
> Yeah that's indeed a point in favour of this patch.
> 
> I prefer to let you guys have the final word on this patch. Whether you
> apply it or not, I fear I'll never be entirely happy either way :)
> That's the sad fate of dealing with circular dependencies...

plus the butt ugly softirq semantics or the lack thereof ...

