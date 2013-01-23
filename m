Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3AWPfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:35:19 -0500
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:42984 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3AWPfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:35:15 -0500
Message-ID: <20130123173510.14986sla4qsstz8k@www.dalek.fi>
Date: Wed, 23 Jan 2013 17:35:10 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues,
 indent, and testmgr build issues
References: <1776726593.108228.1358952383104.JavaMail.root@elliptictech.com>
In-Reply-To: <1776726593.108228.1358952383104.JavaMail.root@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tom St Denis <tstdenis@elliptictech.com>:

> ----- Original Message -----
>> From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
>> To: "Tom St Denis" <tstdenis@elliptictech.com>
>> Cc: linux-kernel@vger.kernel.org, "Herbert Xu"  
>> <herbert@gondor.apana.org.au>, "David Miller" <davem@davemloft.net>,
>> linux-crypto@vger.kernel.org, "Steffen Klassert"  
>> <steffen.klassert@secunet.com>, netdev@vger.kernel.org
>> Sent: Wednesday, 23 January, 2013 9:36:44 AM
>> Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch  
>> issues, indent, and testmgr build issues
>>
>> Quoting Tom St Denis <tstdenis@elliptictech.com>:
>>
>> > Hey all,
>> >
>> > Here's an updated patch which addresses a couple of build issues
>> > and
>> > coding style complaints.
>> >
>> > I still can't get it to run via testmgr I get
>> >
>> > [  162.407807] alg: No test for cmac(aes) (cmac(aes-generic))
>> >
>> > Despite the fact I have an entry for cmac(aes) (much like
>> > xcbc(aes)...).
>> >
>> > Here's the patch to bring 3.8-rc4 up with CMAC ...
>> >
>> > Signed-off-by: Tom St Denis <tstdenis@elliptictech.com>
>> >
>> <snip>
>> > diff --git a/include/uapi/linux/pfkeyv2.h
>> > b/include/uapi/linux/pfkeyv2.h
>> > index 0b80c80..d61898e 100644
>> > --- a/include/uapi/linux/pfkeyv2.h
>> > +++ b/include/uapi/linux/pfkeyv2.h
>> > @@ -296,6 +296,7 @@ struct sadb_x_kmaddress {
>> >  #define SADB_X_AALG_SHA2_512HMAC	7
>> >  #define SADB_X_AALG_RIPEMD160HMAC	8
>> >  #define SADB_X_AALG_AES_XCBC_MAC	9
>> > +#define SADB_X_AALG_AES_CMAC_MAC	10
>> >  #define SADB_X_AALG_NULL		251	/* kame */
>> >  #define SADB_AALG_MAX			251
>>
>> Should these values be based on IANA assigned IPSEC AH transform
>> identifiers?
>>
>> https://www.iana.org/assignments/isakmp-registry/isakmp-registry.xml#isakmp-registry-6
>
> There is no CMAC entry apparently ... despite the fact that CMAC is  
> a proposed RFC standard for IPsec.
>
> It might be safer to move that to 14 since it's currently unassigned  
> and then go through whatever channels are required to allocate it.   
> Mostly this affects key setting.  So this means my patch would break  
> AH_RSA setkey calls (which the kernel doesn't support anyways).
>

Problem seems to be that PFKEYv2 does not quite work with IKEv2, and  
XFRM API should be used instead. There is new numbers assigned for  
IKEv2:  
https://www.iana.org/assignments/ikev2-parameters/ikev2-parameters.xml#ikev2-parameters-7

For new SADB_X_AALG_*, I'd think you should use value from "Reserved  
for private use" range. Maybe 250?

But maybe better solution might be to not make AES-CMAC (or other new  
algorithms) available throught PFKEY API at all, just XFRM?

-Jussi


