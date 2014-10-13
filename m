Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaJMUHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:07:08 -0400
Received: from rgout02.bt.lon5.cpcloud.co.uk ([65.20.0.179]:2804 "EHLO
	rgout02.bt.lon5.cpcloud.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753387AbaJMUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:07:06 -0400
X-CTCH-RefID: str=0001.0A090201.543C30E6.0243,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-Junkmail-Premium-Raw: score=28/50,refid=2.7.2:2014.10.10.71820:17:28.905,ip=81.158.78.155,rules=__MOZILLA_MSGID,
 __HAS_MSGID, __SANE_MSGID, __HAS_FROM, __PHISH_FROM2, __FRAUD_WEBMAIL_FROM,
 __USER_AGENT, __MOZILLA_USER_AGENT, __MIME_VERSION, __TO_MALFORMED_2,
 __MULTIPLE_RCPTS_CC_X2, __BOUNCE_CHALLENGE_SUBJ, __BOUNCE_NDR_SUBJ_EXEMPT,
 __SUBJ_ALPHA_END, __IN_REP_TO, __CT, __CT_TEXT_PLAIN, __CTE,
 __SUBJ_ALPHA_NEGATE, __FORWARDED_MSG, BODYTEXTP_SIZE_3000_LESS,
 BODY_SIZE_2000_2999, __MIME_TEXT_ONLY, RDNS_GENERIC_POOLED,
 SXL_IP_DYNAMIC[155.78.158.81.fur], HTML_00_01, HTML_00_10,
 BODY_SIZE_5000_LESS, RDNS_SUSP_GENERIC, __PHISH_FROM, MULTIPLE_RCPTS,
 __PHISH_SPEAR_STRUCTURE_1, RDNS_SUSP, __FRAUD_WEBMAIL, BODY_SIZE_7000_LESS,
 NO_URI_FOUND
X-CTCH-Spam: Unknown
Message-ID: <543C3229.2090205@btinternet.com>
Date: Mon, 13 Oct 2014 21:12:25 +0100
From: Michael Roocroft <mike.linux@btinternet.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Crypto: gf128mul : fixed a parentheses coding style issue
References: <1413146950-932-1-git-send-email-mike.linux@btinternet.com> <1413154885.22149.49.camel@joe-AO725>
In-Reply-To: <1413154885.22149.49.camel@joe-AO725>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/13/14 00:01, Joe Perches wrote:
> On Sun, 2014-10-12 at 21:49 +0100, Mike Roocroft wrote:
>> Fixed a coding style issue.
> []
>> diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
> []
>> @@ -97,7 +97,7 @@
>>       the table above
>>   */
>>   
>> -#define xx(p, q)	0x##p##q
>> +#define xx(p, q)	(0x##p##q)
>>   
>>   #define xda_bbe(i) ( \
>>   	(i & 0x80 ? xx(43, 80) : 0) ^ (i & 0x40 ? xx(21, c0) : 0) ^ \
> I think that macro is pretty useless and nothing
> but obfuscation now.
>
> The comment above it doesn't seem useful either.
>
> How about just removing and replacing the uses
> like this?
>
> ---
>   crypto/gf128mul.c | 27 ++++++++-------------------
>   1 file changed, 8 insertions(+), 19 deletions(-)
>
> diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
> index 5276607..90cf17d 100644
> --- a/crypto/gf128mul.c
> +++ b/crypto/gf128mul.c
> @@ -88,29 +88,18 @@
>   	q(0xf8), q(0xf9), q(0xfa), q(0xfb), q(0xfc), q(0xfd), q(0xfe), q(0xff) \
>   }
>   
> -/*	Given the value i in 0..255 as the byte overflow when a field element
> -    in GHASH is multiplied by x^8, this function will return the values that
> -    are generated in the lo 16-bit word of the field value by applying the
> -    modular polynomial. The values lo_byte and hi_byte are returned via the
> -    macro xp_fun(lo_byte, hi_byte) so that the values can be assembled into
> -    memory as required by a suitable definition of this macro operating on
> -    the table above
> -*/
> -
> -#define xx(p, q)	0x##p##q
> -
>   #define xda_bbe(i) ( \
> -	(i & 0x80 ? xx(43, 80) : 0) ^ (i & 0x40 ? xx(21, c0) : 0) ^ \
> -	(i & 0x20 ? xx(10, e0) : 0) ^ (i & 0x10 ? xx(08, 70) : 0) ^ \
> -	(i & 0x08 ? xx(04, 38) : 0) ^ (i & 0x04 ? xx(02, 1c) : 0) ^ \
> -	(i & 0x02 ? xx(01, 0e) : 0) ^ (i & 0x01 ? xx(00, 87) : 0) \
> +	(i & 0x80 ? 0x4380 : 0) ^ (i & 0x40 ? 0x21c0 : 0) ^ \
> +	(i & 0x20 ? 0x10e0 : 0) ^ (i & 0x10 ? 0x0870 : 0) ^ \
> +	(i & 0x08 ? 0x0438 : 0) ^ (i & 0x04 ? 0x021c : 0) ^ \
> +	(i & 0x02 ? 0x010e : 0) ^ (i & 0x01 ? 0x0087 : 0) \
>   )
>   
>   #define xda_lle(i) ( \
> -	(i & 0x80 ? xx(e1, 00) : 0) ^ (i & 0x40 ? xx(70, 80) : 0) ^ \
> -	(i & 0x20 ? xx(38, 40) : 0) ^ (i & 0x10 ? xx(1c, 20) : 0) ^ \
> -	(i & 0x08 ? xx(0e, 10) : 0) ^ (i & 0x04 ? xx(07, 08) : 0) ^ \
> -	(i & 0x02 ? xx(03, 84) : 0) ^ (i & 0x01 ? xx(01, c2) : 0) \
> +	(i & 0x80 ? 0xe100 : 0) ^ (i & 0x40 ? 0x7080 : 0) ^ \
> +	(i & 0x20 ? 0x3840 : 0) ^ (i & 0x10 ? 0x1c20 : 0) ^ \
> +	(i & 0x08 ? 0x0e10 : 0) ^ (i & 0x04 ? 0x0708 : 0) ^ \
> +	(i & 0x02 ? 0x0384 : 0) ^ (i & 0x01 ? 0x01c2 : 0) \
>   )
>   
>   static const u16 gf128mul_table_lle[256] = gf128mul_dat(xda_lle);
>
>
>
Hi there,

I'm not really contributing anything other than getting code checkpatch clean, whilst

I relearn C and get a feel for various parts of the kernel.

