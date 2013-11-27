Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3K0Myg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:54:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab3K0Myd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:54:33 -0500
Message-ID: <5295EB77.8040803@redhat.com>
Date: Wed, 27 Nov 2013 13:54:15 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
CC: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        James Yonan <james@openvpn.net>, Florian Weimer <fw@deneb.enyo.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: more robust crypto_memneq
References: <1385424041-18064-1-git-send-email-cesarb@cesarb.eti.br> <5294F625.5040506@redhat.com> <52951640.6080805@cesarb.eti.br>
In-Reply-To: <52951640.6080805@cesarb.eti.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:44 PM, Cesar Eduardo Barros wrote:
> Em 26-11-2013 17:27, Daniel Borkmann escreveu:
>> On 11/26/2013 01:00 AM, Cesar Eduardo Barros wrote:
>>> Compile-tested on x86_64.
>>
>> Actually with yet another version, I hoped that the "compile-tested"-only
>> statement would eventually disappear, ohh well. ;)
>
> I did compile test each version ;-) including verifying (with "make crypto/memneq.i") that the macro was really generating the expected inline assembly (with these #ifdef chains, one has to be careful with typos).
>
> (Actually, I compile tested with "make crypto/memneq.o crypto/memneq.s crypto/memneq.i". I took a peek at the assembly to see if it made sense.)
>
>> Resolving the OPTIMIZER_HIDE_VAR() macro for others than GCC jnto a
>> barrier() seems a bit suboptimal, but assuming 99% of people will use
>> GCC anyway, then for the minority of the remaining, they will worst case
>> have a clever compiler and eventually mimic memcmp() in some situations,
>> or have a not-so-clever compiler and execute the full code as is.
>
> I do not think any compiler other than gcc and icc can compile unmodified upstream kernel code. LLVM's clang would be the one which comes closest, but it has gcc-compatible inline assembly, as does icc AFAIK.
>
> The #define to barrier() within compiler-intel.h is for some compiler called ECC (not icc). From what I could find about it on a quick search, it appears to be some kind of Itanium compiler.
>
> That part of the header was added back in 2003, and I do not believe it is still relevant. A comment within that #ifdef block says "Intel ECC compiler doesn't support gcc specific asm stmts", but there are many uses of unprotected inline assembly all over the kernel (including on the ia64 headers), so if that comment is true, the kernel will not compile with that compiler. It is probably a piece of leftover dead code. I only added to it because I am following RELOC_HIDE's example, and RELOC_HIDE is there.

Yep.

Acked-by: Daniel Borkmann <dborkman@redhat.com>

>> Anyway, I think still better than the rather ugly Makefile workaround
>> imho, so I'm generally fine with this.
