Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3AWQZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:25:38 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:38592 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756437Ab3AWQZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:25:22 -0500
Message-ID: <51000EEF.7090308@linux-ipv6.org>
Date: Thu, 24 Jan 2013 01:25:19 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
CC: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Tom St Denis <tstdenis@elliptictech.com>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent,
 and testmgr build issues
References: <1776726593.108228.1358952383104.JavaMail.root@elliptictech.com> <20130123173510.14986sla4qsstz8k@www.dalek.fi> <51000CEE.9060109@linux-ipv6.org>
In-Reply-To: <51000CEE.9060109@linux-ipv6.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki wrote:
> Jussi Kivilinna wrote:
> 
>>>>> diff --git a/include/uapi/linux/pfkeyv2.h
>>>>> b/include/uapi/linux/pfkeyv2.h
>>>>> index 0b80c80..d61898e 100644
>>>>> --- a/include/uapi/linux/pfkeyv2.h
>>>>> +++ b/include/uapi/linux/pfkeyv2.h
>>>>> @@ -296,6 +296,7 @@ struct sadb_x_kmaddress {
>>>>>  #define SADB_X_AALG_SHA2_512HMAC    7
>>>>>  #define SADB_X_AALG_RIPEMD160HMAC    8
>>>>>  #define SADB_X_AALG_AES_XCBC_MAC    9
>>>>> +#define SADB_X_AALG_AES_CMAC_MAC    10
>>>>>  #define SADB_X_AALG_NULL        251    /* kame */
>>>>>  #define SADB_AALG_MAX            251
>>>>
>>>> Should these values be based on IANA assigned IPSEC AH transform
>>>> identifiers?
>>>>
>>>> https://www.iana.org/assignments/isakmp-registry/isakmp-registry.xml#isakmp-registry-6
>>>
>>> There is no CMAC entry apparently ... despite the fact that CMAC is a proposed RFC standard for IPsec.
>>>
>>> It might be safer to move that to 14 since it's currently unassigned and then go through whatever channels are required to allocate it.  Mostly this affects key setting.  So this means my patch would break AH_RSA setkey calls (which the kernel doesn't support anyways).
>>>
>>
>> Problem seems to be that PFKEYv2 does not quite work with IKEv2, and XFRM API should be used instead. There is new numbers assigned for IKEv2: https://www.iana.org/assignments/ikev2-parameters/ikev2-parameters.xml#ikev2-parameters-7
>>
>> For new SADB_X_AALG_*, I'd think you should use value from "Reserved for private use" range. Maybe 250?
> 
> We can choose any value unless we do not break existing
> binaries.  When IKE used, the daemon is responsible
> for translation.

I meant, we can choose any values "if" we do not break ...

--yoshfuji

