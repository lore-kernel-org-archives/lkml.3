Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaAOXWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:22:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52110 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaAOXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:22:06 -0500
Date: Thu, 16 Jan 2014 00:21:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>, Matt Turner <mattst88@gmail.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140115232134.GM31570@twins.programming.kicks-ass.net>
References: <52D4172E.6030706@hp.com>
 <52D4A0C7.5070601@numascale.com>
 <20140114110307.GW7572@laptop.programming.kicks-ass.net>
 <CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
 <52D57B60.9020209@twiddle.net>
 <20140114234443.GY10038@linux.vnet.ibm.com>
 <CA+55aFyF2Vg785qO52fJLV7rsi6bMtGFhxsAvJ7354EBrcESCA@mail.gmail.com>
 <20140115023958.GA10038@linux.vnet.ibm.com>
 <20140115080753.GW31570@twins.programming.kicks-ass.net>
 <20140115205346.GF10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115205346.GF10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 12:53:46PM -0800, Paul E. McKenney wrote:
> But we did drop support for SMP i386 quite some time ago, so perhaps
> it is time to drop support for SMP Alpha pre-EV56.

So while the primitive is called smp_store_release() the !SMP variant
still does:
 
  *(volatile __type *) = ptr;

which should not compile on any Alpha pre EV56, SMP or no for __type ==
u8.
