Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaF2Dro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 23:47:44 -0400
Received: from mail.eperm.de ([89.247.134.16]:49662 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbaF2Drn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 23:47:43 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
Date: Sun, 29 Jun 2014 05:46:46 +0200
Message-ID: <4311965.FMe9YfRAnU@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140629122402.0fd014d8@canb.auug.org.au>
References: <4927386.WYHrRe3NJm@myon.chronox.de> <10901956.0EDQunEZJL@myon.chronox.de> <20140629122402.0fd014d8@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 29. Juni 2014, 12:24:02 schrieb Stephen Rothwell:

Hi Stephen,

> Hi Stephan,
> 
> On Sat, 28 Jun 2014 22:01:46 +0200 Stephan Mueller <smueller@chronox.de> 
wrote:
> > @@ -1987,8 +1987,9 @@ static int __init drbg_init(void)
> > 
> >  	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
> >  	
> >  		pr_info("DRBG: Cannot register all DRBG types"
> > 
> > -			"(slots needed: %lu, slots available: %lu)\n",
> > -			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
> > +			"(slots needed: %u, slots available: %u)\n",
> > +			(unsigned int)ARRAY_SIZE(drbg_cores) * 2,
> > +			(unsigned int)ARRAY_SIZE(drbg_algs));
> 
> Doesn't ARRAY_SIZE() always return a size_t?  In which case surely we
> need no casts, but need to us %zu in the format string.

Unfortunately not at all. On my x86_64, I get the compiler warning that 
ARRAY_SIZE is a long unsigned int without the cast.

Ciao
Stephan
-- 
| Cui bono? |
