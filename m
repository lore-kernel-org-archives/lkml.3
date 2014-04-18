Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaDRE7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 00:59:15 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:41071 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaDRE7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 00:59:09 -0400
Date: Fri, 18 Apr 2014 12:58:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marek Vasut <marex@denx.de>, Jianyu Zhan <nasa4836@gmail.com>,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sha{256,512}_ssse3 - remove asmlinkage from
 static functions
Message-ID: <20140418045828.GA31103@gondor.apana.org.au>
References: <1397665190-12491-1-git-send-email-nasa4836@gmail.com>
 <201404171728.41994.marex@denx.de>
 <5350AEF4.9060905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5350AEF4.9060905@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 09:49:56PM -0700, H. Peter Anvin wrote:
> On 04/17/2014 08:28 AM, Marek Vasut wrote:
> > On Wednesday, April 16, 2014 at 06:19:50 PM, Jianyu Zhan wrote:
> >> Commit 128ea04a9885("lto: Make asmlinkage __visible") restricts
> >> asmlinkage to externally_visible, this causes compilation warnings:
> >>
> >>     arch/x86/crypto/sha256_ssse3_glue.c:56:1:
> >>     warning: ‘externally_visible’ attribute have effect only on public
> >> objects [-Wattributes]
> >>
> >>     static asmlinkage void (*sha256_transform_asm)(const char *, u32 *,
> >> u64); ^
> >>
> >>     arch/x86/crypto/sha512_ssse3_glue.c:55:1:
> >>     warning: ‘externally_visible’ attribute have effect only on public
> >> objects [-Wattributes] static asmlinkage void
> >> (*sha512_transform_asm)(const char *, u64 *, ^
> >>
> >> Drop asmlinkage here to avoid such warnings.
> >>
> >> Also see Commit 8783dd3a37a5853689e1("irqchip: Remove asmlinkage from
> >> static functions")
> >>
> >> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> > 
> > Makes sense, please add my humble
> > 
> > Reviewed-by: Marek Vasut <marex@denx.de>
> > 
> 
> It doesn't make sense, sorry.  The right thing to drop here is not
> "asmlinkage", it is "static": this is an external declaration.

It's a function pointer that's static, not the function that
it's pointing to.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
