Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaHJI5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 04:57:52 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:46470
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751194AbaHJI5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 04:57:50 -0400
Message-ID: <53E733EF.80003@freescale.com>
Date: Sun, 10 Aug 2014 11:57:19 +0300
From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Cristian Stoica <cristian.stoica@freescale.com>,
        <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>
Subject: Re: [PATCH 2/3] crypto: testmgr.c: white space removal on __test_skcipher
References: <53E496E4.9070207@freescale.com>
 <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
 <1407497272-9161-2-git-send-email-cristian.stoica@freescale.com>
In-Reply-To: <1407497272-9161-2-git-send-email-cristian.stoica@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(164054003)(199002)(51704005)(24454002)(479174003)(377454003)(74662001)(74502001)(99396002)(31966008)(50986999)(76176999)(81542001)(33656002)(102836001)(85182001)(87936001)(107046002)(46102001)(26826002)(65816999)(79102001)(95666004)(85306004)(104016003)(80022001)(65956001)(105606002)(69596002)(54356999)(106466001)(65806001)(81342001)(47776003)(81156004)(83506001)(64706001)(50466002)(21056001)(6806004)(83322001)(44976005)(19580405001)(19580395003)(4396001)(36756003)(86362001)(92726001)(92566001)(68736004)(20776003)(84676001)(64126003)(23676002)(76482001)(97736001)(85852003)(83072002)(77982001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0621;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 029976C540
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Horia.Geanta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/2014 2:27 PM, Cristian Stoica wrote:
> This patch inverts two if conditions to remove code blocks
> indentation. Several white space clean-ups follow.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  crypto/testmgr.c | 283 ++++++++++++++++++++++++++-----------------------------
>  1 file changed, 136 insertions(+), 147 deletions(-)

Don't add more checkpatch warnings on top of existing ones.

> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 51f47f2..36f45ff 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -974,73 +974,69 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
>  		else
>  			memset(iv, 0, MAX_IVLEN);
>  
> -		if (!(template[i].np) || (template[i].also_non_np)) {
> -			j++;
> +		if (template[i].np && !template[i].also_non_np)
> +			continue;
>  
> -			ret = -EINVAL;
> -			if (WARN_ON(align_offset + template[i].ilen >
> -				    PAGE_SIZE))
> -				goto out;
> +		j++;
>  
> -			data = xbuf[0];
> -			data += align_offset;
> -			memcpy(data, template[i].input, template[i].ilen);
> +		ret = -EINVAL;
> +		if (WARN_ON(align_offset + template[i].ilen > PAGE_SIZE))
> +			goto out;
>  
> -			crypto_ablkcipher_clear_flags(tfm, ~0);
> -			if (template[i].wk)
> -				crypto_ablkcipher_set_flags(
> -					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
> +		data = xbuf[0];
> +		data += align_offset;
> +		memcpy(data, template[i].input, template[i].ilen);
>  
> -			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
> -						       template[i].klen);
> -			if (!ret == template[i].fail) {
> -				pr_err("alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
> -				       d, j, algo,
> -				       crypto_ablkcipher_get_flags(tfm));
> -				goto out;
> -			} else if (ret)
> -				continue;
> +		crypto_ablkcipher_clear_flags(tfm, ~0);
> +		if (template[i].wk)

WARNING: line over 80 characters
#58: FILE: crypto/testmgr.c:992:

> +			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);

[...]

> @@ -1055,116 +1051,109 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
>  		else
>  			memset(iv, 0, MAX_IVLEN);
>  
> -		if (template[i].np) {
> -			j++;
> +		if (!template[i].np)
> +			continue;
>  
> -			crypto_ablkcipher_clear_flags(tfm, ~0);
> -			if (template[i].wk)
> -				crypto_ablkcipher_set_flags(
> -					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
> +		j++;
>  
> -			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
> -						       template[i].klen);
> -			if (!ret == template[i].fail) {
> -				pr_err("alg: skcipher%s: setkey failed on chunk test %d for %s: flags=%x\n",
> -				       d, j, algo,
> -				       crypto_ablkcipher_get_flags(tfm));
> -				goto out;
> -			} else if (ret)
> -				continue;
> +		crypto_ablkcipher_clear_flags(tfm, ~0);
> +		if (template[i].wk)

WARNING: line over 80 characters
#170: FILE: crypto/testmgr.c:1061:

> +			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);

Thanks,
Horia


