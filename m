Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3BEKrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:47:41 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:54372 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab3BEKrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:47:35 -0500
Date: Tue, 5 Feb 2013 11:47:32 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3] crypto: add support for the NIST CMAC hash
Message-ID: <20130205104732.GG23291@secunet.com>
References: <793795323.107470.1358944861780.JavaMail.root@elliptictech.com>
 <1550166788.107475.1358944981220.JavaMail.root@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550166788.107475.1358944981220.JavaMail.root@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 05 Feb 2013 10:47:32.0360 (UTC) FILETIME=[3370E880:01CE038E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 07:43:01AM -0500, Tom St Denis wrote:
> Signed-off-by: Tom St Denis <tstdenis@elliptictech.com>
> diff --git a/include/uapi/linux/pfkeyv2.h b/include/uapi/linux/pfkeyv2.h
> index 0b80c80..d61898e 100644
> --- a/include/uapi/linux/pfkeyv2.h
> +++ b/include/uapi/linux/pfkeyv2.h
> @@ -296,6 +296,7 @@ struct sadb_x_kmaddress {
>  #define SADB_X_AALG_SHA2_512HMAC	7
>  #define SADB_X_AALG_RIPEMD160HMAC	8
>  #define SADB_X_AALG_AES_XCBC_MAC	9
> +#define SADB_X_AALG_AES_CMAC_MAC	10

We added the infrastructure to use non pfkey algorithms in the
ipsec-next tree, so we don't need to add a SADB id for pfkey.

The cmac algorithm is then available if the netlink interface
is used to add the cmac SA. We can add pfkey support later
if cmac gets an official ikev1 iana transform identifier. 

Please remove this pfkey stuff and rebase your patch to
ipsec-next/master to ensure that your patch applies cleanly.

Thanks!
