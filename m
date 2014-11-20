Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaKTErC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 23:47:02 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:51963 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaKTErA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 23:47:00 -0500
Date: Thu, 20 Nov 2014 12:46:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: crypto: user - Allow get request with empty driver name
Message-ID: <20141120044650.GA28691@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <1886827.KUDIsNtfuk@tachyon.chronox.de>
 <20141120041824.GA28612@gondor.apana.org.au>
 <3538055.XH2t7HNEVj@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3538055.XH2t7HNEVj@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:23:23AM +0100, Stephan Mueller wrote:
> 
> Here is the code:
> 
> static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
> 			 struct nlattr **attrs)
> {
> ...
> 	if (!p->cru_driver_name[0])
> 		return -EINVAL;

OK let's fix this.

crypto: user - Allow get request with empty driver name
    
Currently all get requests with an empty driver name fail with
EINVAL.  Since most users actually want to supply an empty driver
name this patch removes this check.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index e2a34fe..0bb30ac 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -201,10 +201,7 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
 		return -EINVAL;
 
-	if (!p->cru_driver_name[0])
-		return -EINVAL;
-
-	alg = crypto_alg_match(p, 1);
+	alg = crypto_alg_match(p, 0);
 	if (!alg)
 		return -ENOENT;
 
Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
