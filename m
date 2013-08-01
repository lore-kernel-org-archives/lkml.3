Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab3HAILk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:11:40 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:30184
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab3HAILb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:11:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Stoica Cristian-B18196 <B18196@freescale.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Subject: RE: [PATCH] crypto: remove double execution of the same test suite
Thread-Topic: [PATCH] crypto: remove double execution of the same test suite
Thread-Index: AQHOg9FdzcCcDGTvdUiYyn1yFz3yGZl/meaAgAB4waA=
Date: Thu, 1 Aug 2013 08:11:25 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE4D31E1@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
 <20130801004757.GA24286@gondor.apana.org.au>
In-Reply-To: <20130801004757.GA24286@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.171.73.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which algorithm (apart from crc* which I know and will fix) uses the
> same driver name as its algorithm name? Doing this will cause issues
> when an alternative implementation for that algorithm gets added.

Fixing names resolves double calls only for the thread cryptomgr_test->alg_test where the call is:
    err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);

It doesn't fix the thread tcrypt_test->alg_test where the call is:
    ret = alg_test(alg, alg, 0, 0);

Cristian S.

