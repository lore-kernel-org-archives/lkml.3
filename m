Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3JNVdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:33:16 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:45860 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3JNVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:33:14 -0400
MIME-Version: 1.0
In-Reply-To: <1420251.G1iR4tbUp8@tauon>
References: <2579337.FPgJGgHYdz@tauon>
	<3593500.a7fOuGKlEX@tauon>
	<CACXcFm=M2Jrra3tttWyhwfs-a6iVm0joiKi=wHKuANe_s_F-Sw@mail.gmail.com>
	<1420251.G1iR4tbUp8@tauon>
Date: Mon, 14 Oct 2013 17:33:13 -0400
Message-ID: <CACXcFm=jK=DuzaJFwEBK58wYJ96PSS317uOtc5BieXwjy4oVnQ@mail.gmail.com>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
From: Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller <smueller@chronox.de> wrote:

> [quoting me]

>> ...your code is basically, with 64-bit x:
>>
>>   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) )
>>        x |= bit()
>
> Why not declare some 64-bit constant C with a significant
>>number of bits set and do this:
>>
>>   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) ) // same loop control
>>      if( bit() ) x ^= C ;
>>
>>This makes every output bit depend on many input bits
>>and costs almost nothing extra.

> Ok, let me play a bit with that. Maybe I can add another flag to the
> allocation function so that the caller can decide whether to use that.
> If the user is another RNG, you skip that mixing function, otherwise you
> should take it.

I'd say just do it. It is cheap enough and using it does no harm
even where it is not strictly needed. Adding a flag just gives the
calling code a chance to get it wrong. Better not to take that risk
if you don't have to.
