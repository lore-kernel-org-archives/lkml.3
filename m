Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaEXRv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 13:51:59 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40078 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEXRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 13:51:43 -0400
X-Auth-Info: xr6pmiN/vBLpyH5cgAja1NcU3MHS8rAookWjaxq9Nug=
From: Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86/sha1: fix coverity CID 1195603
Date: Sat, 24 May 2014 14:30:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.12.4; x86_64; ; )
Cc: Milos Vyletel <milos.vyletel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>,
        linux-coverity@vger.kernel.org
References: <1398885474-21388-1-git-send-email-milos.vyletel@gmail.com> <20140508133025.GB12700@gondor.apana.org.au>
In-Reply-To: <20140508133025.GB12700@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201405241430.42673.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 at 03:30:25 PM, Herbert Xu wrote:
> On Wed, Apr 30, 2014 at 03:17:54PM -0400, Milos Vyletel wrote:
> > Coverity detected possible use of uninitialized pointer when printing
> > info message during module load. While this is higly unlikely to cause
> > any troubles simple change in sha1_ssse3_mod_init to make it look like
> > sha256/512 init function will fix this.
> > 
> > 260
> > 
> >    	6. Condition sha1_transform_asm, taking true branch
> > 
> > 261        if (sha1_transform_asm) {
> > 
> > CID 1195603 (#1 of 1): Uninitialized pointer read (UNINIT)
> > 7. uninit_use_in_call: Using uninitialized value algo_name when calling
> > printk. 262                pr_info("Using %s optimized SHA-1
> > implementation\n", algo_name); 263                return
> > crypto_register_shash(&alg);
> > 264        }
> > 
> > Reported-by: <scan-admin@coverity.com>
> > Signed-off-by: Milos Vyletel <milos.vyletel@gmail.com>
> 
> Unless I'm missing something there is no way this code can use
> the variable without initialising it.
> 
> So this is a false positive and I'm not applying this.

I suppose changing the commit message to "align the code with sha256 ... NOTE: 
this also fixed CIDxyz." would work better and might get this applied ? I think 
unification of code is always good.

Best regards,
Marek Vasut
