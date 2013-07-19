Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab3GSGwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 02:52:50 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:10421
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759681Ab3GSGwr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 02:52:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de097h1de096h8275bh8275dha509lz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Gupta Ruchika-R66431 <R66431@freescale.com>
To: Stoica Cristian-B18196 <B18196@freescale.com>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>,
        Stoica Cristian-B18196 <B18196@freescale.com>
Subject: RE: [PATCH] crypto: remove double execution of the same test suite
Thread-Topic: [PATCH] crypto: remove double execution of the same test suite
Thread-Index: AQHOg9FjNPue39lsmE+4dsBBH4vfOplrkT/w
Date: Fri, 19 Jul 2013 06:52:43 +0000
Message-ID: <B2B5EF0D8FDD10429C8DE6C4C2B38282093EE905@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
In-Reply-To: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.60]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Ruchika Gupta <ruchika.gupta@freescale.com>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Cristian Stoica
> Sent: Thursday, July 18, 2013 9:27 PM
> To: herbert@gondor.hengli.com.au
> Cc: davem@davemloft.net; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org; Geanta Neag Horia Ioan-B05471; Stoica Cristian-
> B18196
> Subject: [PATCH] crypto: remove double execution of the same test suite
> 
> This patch removes redundant execution of the same test suite in cases where
> alg and driver variables are the same (e.g. when alg_test is called from
> tcrypt_test)
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  crypto/testmgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c index 2f00607..e091ef6
> 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -3234,7 +3234,7 @@ int alg_test(const char *driver, const char *alg, u32
> type, u32 mask)
>  	if (i >= 0)
>  		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
>  					     type, mask);
> -	if (j >= 0)
> +	if (j >= 0 && j != i)
>  		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
>  					     type, mask);
> 
> --
> 1.8.1.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


