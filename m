Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaBCB3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:29:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52309 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaBCB3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:29:36 -0500
Message-ID: <52EEF0C9.8080002@zytor.com>
Date: Sun, 02 Feb 2014 17:28:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
References: <20140202203617.GA9499@logfs.org> <16782692.5vMS7Bhbvf@myon.chronox.de> <20140203012420.GB9499@logfs.org>
In-Reply-To: <20140203012420.GB9499@logfs.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 05:24 PM, Jörn Engel wrote:
> 
> For my part, I think the whole business of estimating entropy is
> bordering on the esoteric.  If the hash on the output side is any
> good, you have a completely unpredictable prng once the entropy pool
> is unpredictable.  Additional random bits are nice, but not all that
> useful.  Blocking /dev/random based on entropy estimates is likewise
> not all that useful.
> 
> Key phrase is "once the entropy pool is unpredictable".  So early in
> bootup it may make sense to estimate the entropy.  But here the
> problem is that you cannot measure entropy, at least not within a
> single system and a reasonable amount of time.  That leaves you with a
> heuristic that, like all heuristics, is wrong.
> 

The entropy bound needs to be a conservative lower bound.  Its main use
is to provide backpressure (should we spend more CPU time producing
entropy) although the forward pressure on /dev/random is potentially
useful for high security applications.

This does NOT mean that zero-credit entropy generation is useless, far
from it.  It just means that we are doing it on an "it can't hurt"
basis, rather than "I know for sure that this is valuable."

	-hpa

