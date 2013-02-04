Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3BDNVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:21:47 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:59891 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755163Ab3BDNVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:21:45 -0500
Date: Mon, 4 Feb 2013 21:21:41 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: use ERR_CAST
Message-ID: <20130204132141.GB21627@gondor.apana.org.au>
References: <1358854166-3952-1-git-send-email-Julia.Lawall@lip6.fr>
 <1358854166-3952-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358854166-3952-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 12:29:26PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Replace PTR_ERR followed by ERR_PTR by ERR_CAST, to be more concise.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression err,x;
> @@
> -       err = PTR_ERR(x);
>         if (IS_ERR(x))
> -                return ERR_PTR(err);
> +                return ERR_CAST(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
