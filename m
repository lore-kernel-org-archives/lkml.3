Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120Ab3HOGXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:23:32 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47456 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3HOGX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:23:29 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-a0-520c73de3eda
Message-id: <520C73D6.3010904@samsung.com>
Date: Thu, 15 Aug 2013 09:23:18 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: joelf@ti.com
Cc: Joe Perches <joe@perches.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 02/10] crypto: omap-aes: Add useful debug macros
References: <1376521969-16807-1-git-send-email-joelf@ti.com>
 <1376521969-16807-3-git-send-email-joelf@ti.com>
 <1376522998.1949.118.camel@joe-AO722> <520C156D.2090003@ti.com>
 <1376527636.1949.120.camel@joe-AO722> <520C472D.8000904@ti.com>
In-reply-to: <520C472D.8000904@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e/4Nd17xTxBBn++GVvMOd/CYrFvI6/F
	7PuPWSw+7pzOarHp8TVWi/v3fjJZXN41h81i9pJ+FosVHV8YLR5sZrJ41r+H0eJ13xpmi/1X
	vBx4PfoeP2f2+PZ1EovHlpU3mTy+vZf12Lyk3uPLqmvMHsdvbGfy+LxJLoAjissmJTUnsyy1
	SN8ugStjxuxeloIm1Yrjm5YwNzBuke5i5OSQEDCROP/pEwuELSZx4d56ti5GLg4hgaWMEo+6
	tzKBJIQEGpkkvp2IhkgsZJTYu/IuG0iCV0BLomvrUUYQm0VAVeLiwS6wSWwCehIbmn+wg9ii
	AhESK5c8YIWoF5T4MfkeWI2IgIDEtXM/mUGGMgvMZZGYevkuUAMHh7CAi8Scx7wQyz4zSvxs
	OQi2gFNATeLRtaPMIDazgI7E/tZpbBC2vMTmNW+ZIS5Vleheu5YN4h1FidOTzzFPYBSehWT3
	LCTts5C0L2BkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREoFfdzAuPWZ1iFGAg1GJhzei
	jTtIiDWxrLgy9xCjBAezkgjvf2+eICHelMTKqtSi/Pii0pzU4kOMTBycUg2MJp25Ed/fLT2/
	onvj32cupidEGnl5vpw4EBeh71r768OTVlOxyzcuxu/KSLJVU9v6eo43R3D76eqpFyPDQ90X
	n/qcqCHEsu7G2+UOW61rxJ9/PBe63rmhreG7btLrWedjDpkvCrn8Y4XZlp5KkdSFAU9nf9h2
	76b/OdOax4tdj+vssGjyzE06pMRSnJFoqMVcVJwIAOM2sTqeAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/13 06:12, Joel Fernandes wrote:
> On 08/14/2013 07:47 PM, Joe Perches wrote:
>> On Wed, 2013-08-14 at 18:40 -0500, Joel Fernandes wrote:
>>> On 08/14/2013 06:29 PM, Joe Perches wrote:
>>>> On Wed, 2013-08-14 at 18:12 -0500, Joel Fernandes wrote:
>>>>> When DEBUG is enabled, these macros can be used to print variables
>>>>> in integer and hex format, and clearly display which registers,
>>>>> offsets and values are being read/written , including printing the
>>>>> names of the offsets and their values.
>>>> []
>>>>> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
>>>> []
>>>>> @@ -15,6 +15,14 @@
>>>>>  
>>>>>  #define pr_fmt(fmt) "%s: " fmt, __func__
>>>>>  
>>>>> +#ifdef DEBUG
>>>>> +#define prn(num) printk(#num "=%d\n", num)
>>>>> +#define prx(num) printk(#num "=%x\n", num)
>>>> pr_debug?
>>> Sure, can change that.
>>>
>>>>> +#else
>>>>> +#define prn(num) do { } while (0)
>>>>> +#define prx(num)  do { } while (0)
>>>>> +#endif
>>>> []
>>>>> @@ -172,13 +180,35 @@ struct omap_aes_dev {
>>>>>  static LIST_HEAD(dev_list);
>>>>>  static DEFINE_SPINLOCK(list_lock);
>>>>>  
>>>>> +#ifdef DEBUG
>>>>> +#define omap_aes_read(dd, offset)					\
>>>>> +	do {								\
>>>>> +		omap_aes_read_1(dd, offset);				\
>>>>> +		pr_debug("omap_aes_read(" #offset ")\n");		\
>>>>> +	} while (0)
>>>>> +
>>>>> +static inline u32 omap_aes_read_1(struct omap_aes_dev *dd, u32 offset)
>>>>> +#else
>>>>>  static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
>>>>> +#endif
>>>>>  {
>>>>>  	return __raw_readl(dd->io_base + offset);
>>>>>  }
>>>>>  
>>>>> +#ifdef DEBUG
>>>>> +#define omap_aes_write(dd, offset, value)				\
>>>>> +	do {								\
>>>>> +		pr_debug("omap_aes_write(" #offset "=%x) value=%d\n",	\
>>>>> +			 offset, value);				\
>>>>> +		omap_aes_write_1(dd, offset, value);			\
>>>>> +	} while (0)
>>>>> +
>>>>> +static inline void omap_aes_write_1(struct omap_aes_dev *dd, u32 offset,
>>>>> +				  u32 value)
>>>>> +#else
>>>>>  static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
>>>>>  				  u32 value)
>>>>> +#endif
>>>>>  {
>>>>>  	__raw_writel(value, dd->io_base + offset);
>>>>>  }
>>>> Umm, yuck?
>>>>
>>>> Is there any real value in read_1 and write_1?
>>> Can you be more descriptive? There is a lot of value in them for debug
>>> to show clearly sequence of read/writes. Moreover, they are no-op'd when
>>> DEBUG is disabled.
>> pr_debug is no-op'd when DEBUG is not #defined.
>> so just use a single
>>
>> omap_aes_write(...)
>> {
>> 	pr_debug(...)
>> 	__raw_writel(...);
>> }
> Actually this doesn't work, as the pr_debug cannot print the name of the
> offset as my original patch set does using "#offset".
>
> There are many places where named offsets are used to pass to
> read/write, and this macro helps to visually see which offset is being
> written to by name.
>
> So the original patch would stand in its current form except for a small
> rewrite of the write debug part of it as follows to be cleaner getting
> rid of the _1. For the read , we still need it as we need to return the
> value from a function which cannot be done in a macro.
>
> So the new patch would look something like this:
>
> #ifdef DEBUG
> #define omap_aes_read(dd, offset)                                      \
>                 omap_aes_read_1(dd, offset);                           \
>                 pr_debug("omap_aes_read(" #offset ")\n");
> static inline u32 omap_aes_read_1(struct omap_aes_dev *dd, u32 offset)
> #else
> static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
> #endif
> {
>         return __raw_readl(dd->io_base + offset);
> }

Bellow version "write" looks much more readable - never re-define
function signature by macro.
Above should be similar as well...

> #ifdef DEBUG
> #define omap_aes_write(dd, offset, value)                              \
>         do {                                                           \
>                 pr_debug("omap_aes_write(" #offset "=%x) value=%d\n",  \
>                          offset, value);                               \
>                 __raw_writel(value, dd->io_base + offset);             \
>         } while (0)
> #else
> static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
>                                   u32 value)
> {
>         __raw_writel(value, dd->io_base + offset);
> }
> #endif

>
>
> Thanks,
>
> -Joel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

