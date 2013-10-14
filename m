Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab3JNP1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:27:09 -0400
Received: from mail.eperm.de ([89.247.134.16]:34025 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130Ab3JNP1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:27:06 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 14 Oct 2013 17:26:53 +0200
Message-ID: <1420251.G1iR4tbUp8@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.3-201.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CACXcFm=M2Jrra3tttWyhwfs-a6iVm0joiKi=wHKuANe_s_F-Sw@mail.gmail.com>
References: <2579337.FPgJGgHYdz@tauon> <3593500.a7fOuGKlEX@tauon> <CACXcFm=M2Jrra3tttWyhwfs-a6iVm0joiKi=wHKuANe_s_F-Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Oktober 2013, 11:18:16 schrieb Sandy Harris:

Hi Sandy,

>On Mon, Oct 14, 2013 at 10:40 AM, Stephan Mueller <smueller@chronox.de> 
wrote:
>> Another thing: when you start adding whitening functions, other
>> people
>> are starting (and did -- thus I added section 4.3 to my
>> documentation)
>> to complain that you hide your weaknesses behind the whiteners. I
>> simply want to counter that argument and show that RNG produces
>> white noise without a whitener.
>
>Yes, you absolutely have to test the unwhitened input entropy, and
>provide a way for others to test it so they can have confidence in your
>code and it can be tested again if it is going to be used on some new
>host. You do a fine job of that; your paper has the most detailed
>analysis I have seen. Bravo.

Thank you very much.
>
>However, having done that, I see no reason not to add mixing.
>Using bit() for getting one bit of input and rotl(x) for rotating
>left one bit, your code is basically, with 64-bit x:
>
>   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) )
>        x |= bit()

Ok, let me play a bit with that. Maybe I can add another flag to the 
allocation function so that the caller can decide whether to use that. 
If the user is another RNG, you skip that mixing function, otherwise you 
should take it.

But I need a whitening / mixing function that should not add more 
dependencies on the underlying host. The code you have above would be 
ok.
>
>Why not declare some 64-bit constant C with a significant

Which constant would you take? The CRC twist values? The SHA-1 initial 
values? Or the first few from SHA-256?

>number of bits set and do this:
>
>   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) ) // same loop control
>      if( bit() ) x ^= C ;
>
>This makes every output bit depend on many input bits
>and costs almost nothing extra.

Good point.
>
>In the unlikely event that the overhead here matters,
>your deliberately inefficient parity calculation in bit()
>could easily be made faster to compensate.


I will come back to you on this suggestion.


Ciao
Stephan
