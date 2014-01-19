Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaAST4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:56:05 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:54318 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaAST4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:56:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140119080405.GB10038@linux.vnet.ibm.com>
References: <20140115205346.GF10038@linux.vnet.ibm.com>
	<20140115232134.GM31570@twins.programming.kicks-ass.net>
	<CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
	<20140116103659.GO7572@laptop.programming.kicks-ass.net>
	<20140118100105.GV10038@linux.vnet.ibm.com>
	<20140118113406.GY30183@twins.programming.kicks-ass.net>
	<20140118122548.GX10038@linux.vnet.ibm.com>
	<20140118124136.GZ30183@twins.programming.kicks-ass.net>
	<20140118212227.GA10038@linux.vnet.ibm.com>
	<CA+55aFww9F7DA2V611OjkDyf8nfBVFZkLCu1M243mcj7DKqekA@mail.gmail.com>
	<20140119080405.GB10038@linux.vnet.ibm.com>
Date: Sun, 19 Jan 2014 11:56:02 -0800
X-Google-Sender-Auth: SfurGJNzRPDJ7Ip6nyjFyYvhvNw
Message-ID: <CA+55aFwPpEOqkhi8C=ck+6WFQJHOW3LsNg-0DxjMm9m1HW1AYA@mail.gmail.com>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Matt Turner <mattst88@gmail.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 12:04 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> OK, another approach would be to never add "select ARCH_USE_QUEUE_RWLOCK"
> on Alpha, at least if the queued rwlocks really do want to atomically
> manipulate bytes.  After all, the Alpha systems that I know about don't
> have enough CPUs to make queued rwlocks necessary anyway.
>
> Much simpler solution!
>
> Is this what you were getting at, or am I missing your point?

You're missing something.

Just make the "writer" field be an "int" on little-endian archiectures
(like alpha).

There is no reason for that field to be a "char" to begin with, as far
as I can tell, since the padding of the structure means that it
doesn't save any space. But even if that wasn't true, we could make an
arch-specific type for "minimum type for locking".

So my *point* was that it should be easy enough to just make sure that
any data structures used for locking have types that are appropriate
for that locking.

                      Linus
