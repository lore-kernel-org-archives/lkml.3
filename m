Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbbAYX7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 18:59:17 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55445 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbAYX7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 18:59:14 -0500
Date: Mon, 26 Jan 2015 10:59:08 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Message-ID: <20150125235908.GC18212@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de>
 <6238416.vGUni1CI4i@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6238416.vGUni1CI4i@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 02:19:17AM +0100, Stephan Mueller wrote:
>
> +		if (!aead_writable(sk)) {
> +			/* user space sent too much data */
> +			aead_put_sgl(sk);
> +			err = -EMSGSIZE;
> +			goto unlock;
> +		}
> +
> +		/* allocate a new page */
> +		len = min_t(unsigned long, size, aead_sndbuf(sk));
> +		while (len) {
> +			int plen = 0;
> +
> +			if (sgl->cur >= ALG_MAX_PAGES) {
> +				err = -E2BIG;

Should reset the socket just like EMSGSIZE above.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
