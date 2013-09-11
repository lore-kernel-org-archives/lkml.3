Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab3IKGuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:50:00 -0400
Received: from mail.eperm.de ([89.247.134.16]:52681 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3IKGt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:49:59 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Wed, 11 Sep 2013 08:49:49 +0200
Message-ID: <2947789.S63SVUbC3N@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130910211454.GJ29237@thunk.org>
References: <10005394.BRCyBMYWy3@tauon> <CAMuHMdXcXGpgE5ArcjNU-RgAr52qB8ih_b48jwR=+OqK4RDhFA@mail.gmail.com> <20130910211454.GJ29237@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 10. September 2013, 17:14:54 schrieb Theodore Ts'o:

Hi Theodore,

>On Tue, Sep 10, 2013 at 10:48:00PM +0200, Geert Uytterhoeven wrote:
>> So the first importance for random_get_fast_cycles() is that it needs
>> to be fast. What's most important next: number of bits or
>> high-frequency?
>High-frequency.  For example MIPS has a register which is bumped at
>every clock tick, modulo the number of lines in the TLB.  That's what
>we're probably going to end up using for MIPS, on the assumption that
>the time between interrupts is not likely going to be related to the
>number of lines in the TLB.  :-)
>
>Something like jiffies has lots of bits, but since it's updated at a
>much slower rate, it's not as useful if we are trying to measure
>uncertainity based on the interrupt time.  (Worse yet, depending on
>how the architecture handles the clock, there mgiht be a very high
>correlation between when the jiffies counter gets incremented and the
>timer interrupt....)
>
>And yes, we will need to make sure this gets well documented in the
>sources when we introduce random_get_fast_cycles()....

As general hunch on the speed, I would say is a simple test that two 
adjacent calls to obtain a time stamp show a delta. Eg.

__u64 tmp = random_get_fast_cycles() - random_get_fast_cycles();
if(0 == tmp)
	return fail;
return pass;


>
>Cheers,
>
>						- Ted


Ciao
Stephan
