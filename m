Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaBCPtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:49:45 -0500
Received: from longford.logfs.org ([213.229.74.203]:42701 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaBCPto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:49:44 -0500
Date: Mon, 3 Feb 2014 10:50:42 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140203155042.GD9499@logfs.org>
References: <20140202203617.GA9499@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140202203617.GA9499@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 February 2014 15:36:17 -0500, Jörn Engel wrote:
> 
> Measuring the randomness from random_get_entropy() with above approach
> failed because there was so much randomness.  All numbers in all runs
> were different.  Taking the delta between the numbers, again almost all
> numbers were different with at most 1 identical delta per 1000.
> Compared to a high-precision clock, no other input comes within two
> orders of magnitude.

I think this is a key result from my tests.  The best source is a
timer (counter) that is both
a) high-resolution and
b) asynchronous to the measurement event.

If the measurement event is an interrupt and the CPU has a
cycle-counter, you are set.  On interesting systems lacking a
cycle-counter, we still have a high-resolution counter or sorts that
is the CPU itself.

Instruction pointer and stack pointer for both kernel and userland are
one way to read out the "counter".  Main problem here are tight loops
where your "counter" is not high-resolution at all.  But something
within the CPU is constantly changing.  And that something tends to be
contained in the registers.

How about taking the saved registers from the interrupted CPU, xor'ing
them all and calling the result random_get_entropy() on systems
lacking a good cycles-counter?

Jörn

--
I can say that I spend most of my time fixing bugs even if I have lots
of new features to implement in mind, but I give bugs more priority.
-- Andrea Arcangeli, 2000
