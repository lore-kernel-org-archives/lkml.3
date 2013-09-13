Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3IMBex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:34:53 -0400
Received: from longford.logfs.org ([213.229.74.203]:60277 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3IMBew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:34:52 -0400
Date: Thu, 12 Sep 2013 20:00:11 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130913000011.GJ3809@logfs.org>
References: <20130910203853.GG29237@thunk.org>
 <522F851D.1040101@linaro.org>
 <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
 <20130912233535.GI3809@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130912233535.GI3809@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 September 2013 19:35:36 -0400, Jörn Engel wrote:
> 
> I think the existing code is doing just fine for low interrupt loads.
> It makes sense to spend a bit more work to squeeze the last bit of
> randomness out.  But when you get lots of interrupts, you can be
> sloppy and just xor things into the pool.

Btw, if we make collection cheap enough, we can start collecting
entropy from the scheduler.  Computers are fairly deterministic, but
not that much.  The exact time when calling schedule(), the kernel
stack pointer and the userspace stack pointer all contain a bit of
entropy.  Particularly on machines that lack input and disk
randomness I would expect some benefits from this.

Jörn

--
Audacity augments courage; hesitation, fear.
-- Publilius Syrus
