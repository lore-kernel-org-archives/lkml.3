Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaDKSU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:20:29 -0400
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:48857 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751198AbaDKSU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:20:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2899:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:4250:4321:4605:5007:6117:6119:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12679:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cough19_3d86071342d43
X-Filterd-Recvd-Size: 2410
Message-ID: <1397240421.7113.39.camel@joe-AO722>
Subject: Re: [PATCH v4 1/6] SP800-90A Deterministic Random Bit Generator
From: Joe Perches <joe@perches.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com
Date: Fri, 11 Apr 2014 11:20:21 -0700
In-Reply-To: <3972168.arX3qfUzsN@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de>
	 <3662681.npTzbSq3ye@myon.chronox.de> <1952806.u8ySj6rIyr@myon.chronox.de>
	 <3972168.arX3qfUzsN@myon.chronox.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 20:07 +0200, Stephan Mueller wrote:
> Changes v4:
>  * change return codes of generate functions to signed int to convey error
>    codes and to match the kernel crypto API expecations on the generate
>    function.
>  * add BUG_ON throughout drbg_healthcheck_sanity() since any failure should
>    should be caugth to prevent the DRBG from operating
>  * change layout of debugging printk

It looks like const could be used a bit more often.

For instance:
perhaps uses of key could be changed to const unsigned char *key

> diff --git a/crypto/drbg.c b/crypto/drbg.c
[]
> +#ifdef CONFIG_CRYPTO_DRBG_CTR
> +static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *key,
> +			  unsigned char *outval, struct drbg_string *in);
[]
> +/* BCC function for CTR DRBG as defined in 10.4.3 */
> +static int drbg_ctr_bcc(struct drbg_state *drbg,
> +			unsigned char *out, unsigned char *key,
> +			struct drbg_string *in)
[]
> +/* Derivation Function for CTR DRBG as defined in 10.4.2 */
> +static int drbg_ctr_df(struct drbg_state *drbg,
> +		       unsigned char *df_data, size_t bytes_to_return,
> +		       struct drbg_string *addtl)
> +{
[]
> +	unsigned char *K = (unsigned char *)
> +			   "\x00\x01\x02\x03\x04\x05\x06\x07"
> +			   "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> +			   "\x10\x11\x12\x13\x14\x15\x16\x17"
> +			   "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f";


