Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3ATAMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 19:12:48 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:38610 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389Ab3ATAMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 19:12:46 -0500
Date: Sun, 20 Jan 2013 11:12:36 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/crypto/bfin_crc.c: reposition free_irq to
 avoid access to invalid data
Message-ID: <20130120001236.GA26742@gondor.apana.org.au>
References: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr>
 <1357552816-6046-3-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357552816-6046-3-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 11:00:16AM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The data referenced by an interrupt handler should not be freed before the
> interrupt is ended.  The handler is bfin_crypto_crc_handler.  It may refer
> to crc->regs, which is released by the iounmap.
> 
> Furthermore, the second argument to all calls to free_irq is incorrect.  It
> should be the same as the last argument of request_irq, which is crc,
> rather than crc->dev.
> 
> The semantic match that finds the first problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @fn exists@
> expression list es;
> expression a,b;
> identifier f;
> @@
> 
> if (...) {
>   ... when any
>   free_irq(a,b);
>   ... when any
>   f(es);
>   ... when any
>   return ...;
> }
> 
> @@
> expression list fn.es;
> expression fn.a,fn.b;
> identifier fn.f;
> @@
> 
> *f(es);
> ... when any
> *free_irq(a,b);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Patch applied.

Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
