Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3HALhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:37:54 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:60330 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753801Ab3HALhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:37:51 -0400
Date: Thu, 1 Aug 2013 21:37:47 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stoica Cristian-B18196 <B18196@freescale.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Subject: Re: [PATCH] crypto: remove double execution of the same test suite
Message-ID: <20130801113747.GA30622@gondor.apana.org.au>
References: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
 <20130801004757.GA24286@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE4D31E1@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628287275CAA9409F1E349DEF3C6CCE4D31E1@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 08:11:25AM +0000, Stoica Cristian-B18196 wrote:
> > Which algorithm (apart from crc* which I know and will fix) uses the
> > same driver name as its algorithm name? Doing this will cause issues
> > when an alternative implementation for that algorithm gets added.
> 
> Fixing names resolves double calls only for the thread cryptomgr_test->alg_test where the call is:
>     err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);
> 
> It doesn't fix the thread tcrypt_test->alg_test where the call is:
>     ret = alg_test(alg, alg, 0, 0);

Good point.  I'll apply your patch.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
