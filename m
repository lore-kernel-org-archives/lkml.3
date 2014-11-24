Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaKXO0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:26:49 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:43030 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbaKXO0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:26:47 -0500
Date: Mon, 24 Nov 2014 22:26:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 1/7] crypto: AF_ALG: add user space interface for AEAD
Message-ID: <20141124142639.GA31469@gondor.apana.org.au>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de>
 <5694690.RURGUoE58b@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5694690.RURGUoE58b@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 06:30:18AM +0100, Stephan Mueller wrote:
>
> @@ -421,6 +421,18 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
>  			con->op = *(u32 *)CMSG_DATA(cmsg);
>  			break;
>  
> +		case ALG_SET_AEAD_AUTHSIZE:
> +			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
> +				return -EINVAL;
> +			con->aead_authsize = *(u32 *)CMSG_DATA(cmsg);
> +			break;

This is a tfm attribute so it should go into setsockopt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
