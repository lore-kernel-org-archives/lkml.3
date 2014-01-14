Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaANUUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:20:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43999 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaANUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:20:45 -0500
Date: Tue, 14 Jan 2014 21:20:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Richard Henderson <rth@twiddle.net>, Matt Turner <mattst88@gmail.com>,
        Daniel J Blueman <daniel@numascale.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140114202027.GN7572@laptop.programming.kicks-ass.net>
References: <52D353C8.4000000@numascale.com>
 <52D4172E.6030706@hp.com>
 <52D4A0C7.5070601@numascale.com>
 <20140114110307.GW7572@laptop.programming.kicks-ass.net>
 <CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
 <52D57B60.9020209@twiddle.net>
 <52D58B6A.5070103@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D58B6A.5070103@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 02:09:30PM -0500, Waiman Long wrote:
> I would like to know if the action of writing out a byte (e.g. *byte = 0) is
> atomic in those architectures or is emulated by a compiler-generated
> software read-modify-write.

So on Alpha pre ev56 something like:

  *(volatile u8 *)foo = 0;

_Should_ cause a compile error as the hardware has to do a rmw which is
not compatible with the requirements for volatile -- that said I do not
know if a compiler will actually generate this error.

I can well imagine other load-store archs suffering similar problems,
although I'm not aware of any.
