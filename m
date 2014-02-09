Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaBIJWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 04:22:46 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:40173 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBIJWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 04:22:45 -0500
Date: Sun, 9 Feb 2014 17:22:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Matt Mackall <mpm@selenic.com>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] hw_random: cleanup in hwrng_register()
Message-ID: <20140209092229.GG19429@gondor.apana.org.au>
References: <20140130114943.GB12734@elgon.mountain>
 <87k3dgvgzg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3dgvgzg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 04:18:51PM +1030, Rusty Russell wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> > My static checker complains that:
> >
> > 	drivers/char/hw_random/core.c:341 hwrng_register()
> > 	warn: we tested 'old_rng' before and it was 'false'
> >
> > The problem is that sometimes we test "if (!old_rng)" and sometimes we
> > test "if (must_register_misc)".  The static checker knows they are
> > equivalent but a human being reading the code could easily be confused.
> >
> > I have simplified the code by removing the "must_register_misc" variable
> > and I have removed the redundant check on "if (!old_rng)".
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Yeah, clearer too.
> 
> Reviewed-by: Rusty Russell <rusty@rustcorp.com.au>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
