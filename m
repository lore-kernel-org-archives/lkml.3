Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3AWOq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:46:26 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:13306 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3AWOqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:46:24 -0500
Date: Wed, 23 Jan 2013 09:46:23 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Message-ID: <1776726593.108228.1358952383104.JavaMail.root@elliptictech.com>
In-Reply-To: <20130123163644.19511ochn6jcqobo@www.81.fi>
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent,
 and testmgr build issues
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
> To: "Tom St Denis" <tstdenis@elliptictech.com>
> Cc: linux-kernel@vger.kernel.org, "Herbert Xu" <herbert@gondor.apana.org.au>, "David Miller" <davem@davemloft.net>,
> linux-crypto@vger.kernel.org, "Steffen Klassert" <steffen.klassert@secunet.com>, netdev@vger.kernel.org
> Sent: Wednesday, 23 January, 2013 9:36:44 AM
> Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent, and testmgr build issues
> 
> Quoting Tom St Denis <tstdenis@elliptictech.com>:
> 
> > Hey all,
> >
> > Here's an updated patch which addresses a couple of build issues
> > and
> > coding style complaints.
> >
> > I still can't get it to run via testmgr I get
> >
> > [  162.407807] alg: No test for cmac(aes) (cmac(aes-generic))
> >
> > Despite the fact I have an entry for cmac(aes) (much like
> > xcbc(aes)...).
> >
> > Here's the patch to bring 3.8-rc4 up with CMAC ...
> >
> > Signed-off-by: Tom St Denis <tstdenis@elliptictech.com>
> >
> <snip>
> > diff --git a/include/uapi/linux/pfkeyv2.h
> > b/include/uapi/linux/pfkeyv2.h
> > index 0b80c80..d61898e 100644
> > --- a/include/uapi/linux/pfkeyv2.h
> > +++ b/include/uapi/linux/pfkeyv2.h
> > @@ -296,6 +296,7 @@ struct sadb_x_kmaddress {
> >  #define SADB_X_AALG_SHA2_512HMAC	7
> >  #define SADB_X_AALG_RIPEMD160HMAC	8
> >  #define SADB_X_AALG_AES_XCBC_MAC	9
> > +#define SADB_X_AALG_AES_CMAC_MAC	10
> >  #define SADB_X_AALG_NULL		251	/* kame */
> >  #define SADB_AALG_MAX			251
> 
> Should these values be based on IANA assigned IPSEC AH transform
> identifiers?
> 
> https://www.iana.org/assignments/isakmp-registry/isakmp-registry.xml#isakmp-registry-6

There is no CMAC entry apparently ... despite the fact that CMAC is a proposed RFC standard for IPsec.

It might be safer to move that to 14 since it's currently unassigned and then go through whatever channels are required to allocate it.  Mostly this affects key setting.  So this means my patch would break AH_RSA setkey calls (which the kernel doesn't support anyways).

Tom
