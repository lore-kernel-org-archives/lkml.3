Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaFBXyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:54:00 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57559 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaFBXxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:53:46 -0400
Message-ID: <1401753224.3645.190.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
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
Date: Mon, 02 Jun 2014 16:53:44 -0700
In-Reply-To: <20140602231730.GH22231@linux.vnet.ibm.com>
References: <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
	 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
	 <20140602163032.GI16155@laptop.programming.kicks-ass.net>
	 <538CB56E.5010709@hp.com>
	 <20140602200525.GD13930@laptop.programming.kicks-ass.net>
	 <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
	 <20140602210227.GE22231@linux.vnet.ibm.com>
	 <CA+55aFzX3oDvzqh4AfkJ7-X1Yfo8obFM+jOOmwzeN-GyqOPLJg@mail.gmail.com>
	 <20140602220831.GG22231@linux.vnet.ibm.com>
	 <1401749088.3645.189.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140602231730.GH22231@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 16:17 -0700, Paul E. McKenney wrote:

> But given that I already have preemption disabled and given that
> __srcu_read_lock() is not to be used by irq handlers, I should be able to
> use __this_cpu_inc(), correct?  Just to avoid unnecessary irq disabling
> on non-x86 platforms...

Absolutely, __this_cpu_inc() is OK here.


