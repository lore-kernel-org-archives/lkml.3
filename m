Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3IVVty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:49:54 -0400
Received: from longford.logfs.org ([213.229.74.203]:57935 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3IVVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:49:53 -0400
Date: Sun, 22 Sep 2013 16:31:25 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130922203125.GB4584@logfs.org>
References: <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
 <20130916154026.GA23345@logfs.org>
 <20130921212510.GD8606@thunk.org>
 <20130921214118.GE8606@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130921214118.GE8606@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 September 2013 17:41:18 -0400, Theodore Ts'o wrote:
> 
> BTW, just to give another example of the difference between the mixing
> funtions, try compiling the following with and without ORIG_MIX defined...

Garbage in, garbage out again.  If there is absolutely no randomness
in the input (all bits zero), my mixing function will simply shift the
pool.  And because the shifting has a period of 128, there are only
128 possible pool states.  Your mixing function is doing slightly
better, it effectively becomes an interrupt counter with a silly
output format.

But who cares?  If there is absolutely no randomness in the input, you
have lost.  That case isn't worth contemplating.  The question is
whether any randomness present in the input will get accumulated.

Without the shifting, a single unpredictable bit on, say, the lowest
position of the timestamp will be xor'ed into the same pool bit every
time.  The rest of the pool would always be predictable and the
resulting mixing function would clearly be bad.

With the shifting and using the same example, after 128 rounds every
bit of the pool is unpredictable.  Job done, we can go home now.  You
cannot achieve anything better than 128 unpredictable bits, no matter
how much you try.

Jörn

--
Those who come seeking peace without a treaty are plotting.
-- Sun Tzu
