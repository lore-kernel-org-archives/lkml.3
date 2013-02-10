Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026Ab3BJT1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 14:27:10 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:64665 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760943Ab3BJT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 14:27:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130210185002.GA10801@thunk.org>
References: <51157686.9000404@chronox.de>
	<20130209180629.GD8091@thunk.org>
	<20130210015751.GA13690@unpythonic.net>
	<5117969A.1080909@chronox.de>
	<20130210185002.GA10801@thunk.org>
Date: Sun, 10 Feb 2013 14:27:00 -0500
Message-ID: <CACXcFmm6Xfc_W06DNQ=d0wmGgqFLsUuzCnEivVzoFmKmTNv1GA@mail.gmail.com>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
From: Sandy Harris <sandyinchina@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        Jeff Epler <jepler@unpythonic.net>, linux-crypto@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 1:50 PM, Theodore Ts'o <tytso@mit.edu> wrote:

> On Sun, Feb 10, 2013 at 01:46:18PM +0100, Stephan Mueller wrote:
>>
>> However, the CPU has timing jitter in the execution of instruction. And
>> I try to harvest that jitter. The good thing is that this jitter is
>> always present and can be harvested on demand.
>
> How do you know, though, that this is what you are harvesting?
> ...
> And what's your proof that your entropy source really is an entropy
> source?

One paper that seems to show there is some randomness in
such measurements is McGuire, Okech & Schiesser
"Analysis of inherent randomness of the Linux kernel",
http://lwn.net/images/conf/rtlws11/random-hardware.pdf

They do two clock calls with a usleep() between, take the
low bit of the difference and pack them unmixed into
bytes for testing. Their tests show over 7.5 bits of entropy
per byte, even with interrupts disabled. The same paper
shows that simple arithmetic sequences give some
apparent entropy, due to TLB misses, interrupts, etc.

There are lots of caveats in how this should be used and
it is unclear how much real entropy it gives, but is seems
clear it gives some.

My own program to feed into random(4) is based on
such things:
ftp://ftp.cs.sjtu.edu.cn:990/sandy/maxwell/

HAVEGE also uses them
http://www.irisa.fr/caps/projects/hipsor/
& there is a havegd daemon for Linux
http://www.issihosts.com/haveged/

random(4) also mixed in timer data at one point,
which seems the correct thing for it to do. Later
I heard something about that code having been
removed. What is the current status?
