Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaAUPln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:41:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58363 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAUPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:41:40 -0500
Date: Tue, 21 Jan 2014 16:41:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Turner <mattst88@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140121154113.GB31570@twins.programming.kicks-ass.net>
References: <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
 <20140116103659.GO7572@laptop.programming.kicks-ass.net>
 <20140118100105.GV10038@linux.vnet.ibm.com>
 <20140118113406.GY30183@twins.programming.kicks-ass.net>
 <20140118122548.GX10038@linux.vnet.ibm.com>
 <20140118124136.GZ30183@twins.programming.kicks-ass.net>
 <20140118212227.GA10038@linux.vnet.ibm.com>
 <CA+55aFww9F7DA2V611OjkDyf8nfBVFZkLCu1M243mcj7DKqekA@mail.gmail.com>
 <20140119080405.GB10038@linux.vnet.ibm.com>
 <52DE8BEE.4040303@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE8BEE.4040303@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:02:06AM -0500, Waiman Long wrote:
> My latest v9 series of qrwlock patch will automatically adapt to the lack of
> atomic byte access by using an atomic integer instruction instead. So the
> new series should work for pre-EV56 Alpha, it is just a bit less efficient
> in this case.

See my other email; I don't think you can do that without also changing
the implementation of the queue_read_{try}lock() functions.

Without those changes you can have transient values in your 'read-count'
part of the word and a full word write will wreck things.
