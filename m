Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaFCA2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:28:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47536 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaFCA22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:28:28 -0400
Date: Mon, 2 Jun 2014 17:28:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <waiman.long@hp.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140603002823.GI22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140602163032.GI16155@laptop.programming.kicks-ass.net>
 <538CB56E.5010709@hp.com>
 <20140602200525.GD13930@laptop.programming.kicks-ass.net>
 <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
 <20140602210227.GE22231@linux.vnet.ibm.com>
 <CA+55aFzX3oDvzqh4AfkJ7-X1Yfo8obFM+jOOmwzeN-GyqOPLJg@mail.gmail.com>
 <20140602220831.GG22231@linux.vnet.ibm.com>
 <1401749088.3645.189.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140602231730.GH22231@linux.vnet.ibm.com>
 <1401753224.3645.190.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401753224.3645.190.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060300-0928-0000-0000-000002673339
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 04:53:44PM -0700, Eric Dumazet wrote:
> On Mon, 2014-06-02 at 16:17 -0700, Paul E. McKenney wrote:
> 
> > But given that I already have preemption disabled and given that
> > __srcu_read_lock() is not to be used by irq handlers, I should be able to
> > use __this_cpu_inc(), correct?  Just to avoid unnecessary irq disabling
> > on non-x86 platforms...
> 
> Absolutely, __this_cpu_inc() is OK here.

Cool, giving it a test...

							Thanx, Paul

