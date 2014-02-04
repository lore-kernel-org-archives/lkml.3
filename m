Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaBDUcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:32:13 -0500
Received: from mail.eperm.de ([89.247.134.16]:38564 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbaBDUcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:32:11 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
Date: Tue, 04 Feb 2014 21:31:59 +0100
Message-ID: <1874855.zG4mP2DzbB@tauon>
User-Agent: KMail/4.11.5 (Linux/3.12.7-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <52F13A1C.3040003@zytor.com>
References: <2039634.jSmQAS6tdi@myon.chronox.de> <20140204170823.GF12768@thunk.org> <52F13A1C.3040003@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Februar 2014, 11:06:04 schrieb H. Peter Anvin:

Hi Peter,

>On 02/04/2014 09:08 AM, Theodore Ts'o wrote:
>> I really wish we could get someone inside Intel who has deep
>> knowledge
>> about CPU internals to render an opinion about this.  My reaction to
>> "I can't explain where the entropy is coming from" seems very similar
>> to what my home grown attempts to create an encryption algoritm when
>> I
>> was much younger and much more foolish --- "it must be secure because
>> I can't break it".
>
>I think I have deep enough knowledge about CPU architectures in general
>(as opposed to specific Intel designs, which I wouldn't be able to
>comment on anyway) to comment.  The more modern and high performance a
>design you have the more sources of unpredictability there are.
>However, there are very few, if any, (unintentional) sources of actual
>quantum noise in a synchronous CPU, which means that this is at its
>core a PRNG albeit with a large and rather obfuscated state space.
>
>The quantum noise sources there are in a system are generally two
>independent clocks running against each other.  However, independent
>clocks are rare; instead, most clocks are in fact slaved against each
>other using PLLs and similar structures.  When mixing spread spectrum
>clocks and non-spread-spectrum clocks that relationship can be very
>complex, but at least for some designs it is still at its core
>predictable.

But isn't there an additional clock? The clock used to drive the cache 
and memory bus? When measuring memory accesses timings, larger 
variations in the execution time are evident. This also applies when 
hitting the caches (for L1, the variations are less than for L2 than for 
L3). The variations in access timings would come from the CPU wait 
states and their duration, would it not?

Ciao
Stephan
