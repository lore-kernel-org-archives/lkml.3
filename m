Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbaKTNCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:02:30 -0500
Received: from mail.eperm.de ([89.247.134.16]:54686 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748AbaKTNC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:02:28 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Thu, 20 Nov 2014 14:02:21 +0100
Message-ID: <1706209.Hbu17X87TM@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141120044650.GA28691@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <3538055.XH2t7HNEVj@tachyon.chronox.de> <20141120044650.GA28691@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 20. November 2014, 12:46:50 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 20, 2014 at 05:23:23AM +0100, Stephan Mueller wrote:
> > Here is the code:
> > 
> > static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
> > 
> > 			 struct nlattr **attrs)
> > 
> > {
> > ...
> > 
> > 	if (!p->cru_driver_name[0])
> > 	
> > 		return -EINVAL;
> 
> OK let's fix this.
> 
> crypto: user - Allow get request with empty driver name
> 
> Currently all get requests with an empty driver name fail with
> EINVAL.  Since most users actually want to supply an empty driver
> name this patch removes this check.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Stephan Mueller <smueller@chronox.de>
> 
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index e2a34fe..0bb30ac 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -201,10 +201,7 @@ static int crypto_report(struct sk_buff *in_skb, struct
> nlmsghdr *in_nlh, if (!null_terminated(p->cru_name) ||
> !null_terminated(p->cru_driver_name)) return -EINVAL;
> 
> -	if (!p->cru_driver_name[0])
> -		return -EINVAL;
> -
> -	alg = crypto_alg_match(p, 1);
> +	alg = crypto_alg_match(p, 0);
>  	if (!alg)
>  		return -ENOENT;
> 
> Cheers,


-- 
Ciao
Stephan
