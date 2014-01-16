Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaAPKhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:37:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33787 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAPKhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:37:16 -0500
Date: Thu, 16 Jan 2014 11:36:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Turner <mattst88@gmail.com>, Waiman Long <waiman.long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140116103659.GO7572@laptop.programming.kicks-ass.net>
References: <20140114110307.GW7572@laptop.programming.kicks-ass.net>
 <CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
 <52D57B60.9020209@twiddle.net>
 <20140114234443.GY10038@linux.vnet.ibm.com>
 <CA+55aFyF2Vg785qO52fJLV7rsi6bMtGFhxsAvJ7354EBrcESCA@mail.gmail.com>
 <20140115023958.GA10038@linux.vnet.ibm.com>
 <20140115080753.GW31570@twins.programming.kicks-ass.net>
 <20140115205346.GF10038@linux.vnet.ibm.com>
 <20140115232134.GM31570@twins.programming.kicks-ass.net>
 <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 06:39:23AM +0700, Linus Torvalds wrote:
> On Jan 16, 2014 6:22 AM, "Peter Zijlstra" <peterz@infradead.org> wrote:
> >
> > So while the primitive is called smp_store_release() the !SMP variant
> > still does:
> >
> >   *(volatile __type *) = ptr;
> >
> > which should not compile on any Alpha pre EV56, SMP or no for __type ==
> > u8.
> 
> I'm not sure where you get that "should not compile" theory from.
> 
> I'm pretty sure it will compile just fine. It will just generate the same
> standard read-modify-write sequence (and not using the ldl/stc sequence
> either). Do you have any actual reason to believe it won't, apart from your
> theoretical wishes of how the world should work?

No, I earlier even said it probably would compile. My usage of 'should'
comes from how we've 'defined' volatile/ACCESS_ONCE in
Documentation/memory-barriers.txt. According to those constraints the
rmw cycle is not proper code.
