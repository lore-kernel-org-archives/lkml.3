Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3IBKgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:36:18 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:53920 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758156Ab3IBKgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:36:15 -0400
Date: Mon, 2 Sep 2013 20:35:52 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: dl9pf@gmx.de
Cc: linux-kernel@vger.kernel.org, pageexec@freemail.hu,
        llvmlinux@lists.linuxfoundation.org, behanw@converseincode.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Fix bitoperation for compilation with clang
Message-ID: <20130902103552.GB815@gondor.apana.org.au>
References: <1377799764-14373-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377799764-14373-1-git-send-email-dl9pf@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 08:09:24PM +0200, dl9pf@gmx.de wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> v2: Fix bug in statement as pointed out by Herbert Xu. Kudos to pipacs.
> 
> Author:  PaX Team <pageexec at freemail.hu>
> ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
> URL:     http://llvm.linuxfoundation.org
> 
> Merge:   Jan-Simon Möller <dl9pf at gmx.de>
> 
> Description:
> 
> Fix for warning:
> linux/crypto/fcrypt.c:143:47: warning: signed shift result (0x598000000) requires 36 bits to
>       represent, but 'int' only has 32 bits [-Wshift-overflow]
>         Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61), Z(0xad),
>                                                      ^~~~~~~
> linux/crypto/fcrypt.c:113:29: note: expanded from macro 'Z'
>                             ^  ~~
> linux/include/uapi/linux/byteorder/little_endian.h:38:53: note: expanded from macro
>       '__cpu_to_be32'
>                                                     ^
> linux/include/uapi/linux/swab.h:116:21: note: expanded from macro '__swab32'
>         ___constant_swab32(x) :                 \
>                            ^
> linux/include/uapi/linux/swab.h:18:12: note: expanded from macro '___constant_swab32'
>         (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
>                   ^
> 
> Solution - make sure we don't exceed the 32 bit range.
>  #define Z(x) cpu_to_be32(((x & 0x1f) << 27) | (x >> 5))
> 
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
