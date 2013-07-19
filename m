Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab3GSGtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 02:49:08 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:59678
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759633Ab3GSGtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 02:49:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1155h)
Message-ID: <51E8E14F.8080603@freescale.com>
Date: Fri, 19 Jul 2013 09:48:47 +0300
From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Cristian Stoica <cristian.stoica@freescale.com>
CC: <herbert@gondor.hengli.com.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: remove double execution of the same test suite
References: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
In-Reply-To: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/2013 6:57 PM, Cristian Stoica wrote:
> This patch removes redundant execution of the same test suite in cases
> where alg and driver variables are the same (e.g. when alg_test is
> called from tcrypt_test)
>
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

> ---
>   crypto/testmgr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 2f00607..e091ef6 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -3234,7 +3234,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
>   	if (i >= 0)
>   		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
>   					     type, mask);
> -	if (j >= 0)
> +	if (j >= 0 && j != i)
>   		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
>   					     type, mask);
>
>



