Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3DWDlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 23:41:49 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60909 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3DWDls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 23:41:48 -0400
Message-ID: <517602FC.2080305@igel.co.jp>
Date: Tue, 23 Apr 2013 12:41:48 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH 1/4] arm64: Provide default implementation for dma_{alloc,
 free}_attrs
References: <1366607349-2992-1-git-send-email-dhobsong@igel.co.jp> <5174D47E.3090301@metafoo.de>
In-Reply-To: <5174D47E.3090301@metafoo.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,
On 2013/04/22 15:11, Lars-Peter Clausen wrote:
> On 04/22/2013 07:09 AM, Damian Hobson-Garcia wrote:
>> Most architectures that define CONFIG_HAVE_DMA, have implementations for
>> both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
>> not define CONFIG_HAVE_DMA also have both of these definitions provided by
>> dma-mapping-broken.h.
>>
>> Add default implementations for these functions on arm64.
>>
>> Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
>> ---
>>  arch/arm64/include/asm/dma-mapping.h |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
>> index 9947768..65ab181 100644
>> --- a/arch/arm64/include/asm/dma-mapping.h
>> +++ b/arch/arm64/include/asm/dma-mapping.h
>> @@ -81,6 +81,9 @@ static inline void dma_mark_clean(void *addr, size_t size)
>>  {
>>  }
>>  
>> +#define dma_alloc_attrs(d, s, h, f, a) dma_alloc_coherent(d, s, h, f)
>> +#define dma_free_attrs(d, s, h, f, a) dma_free_coherent(d, s, h, f)
>> +
>>  static inline void *dma_alloc_coherent(struct device *dev, size_t size,
>>  				       dma_addr_t *dma_handle, gfp_t flags)
>>  {
> 
> The other way around would be better, properly implement
> dma_{alloc,free}_attrs and implement dma_{alloc,free}_coherent on top of
> the. E.g. you are supposed to pass the attrs parameter to ops->alloc and
> ops->free instead of NULL. And it will also allow us to move
> dma_{alloc,free}_coherent to asm-generic/dma-mapping-common.h eventually.

Ok, makes sense.  I'll update this for archs that are using dma_map_ops
(arm64 and s390).

Thanks,
Damian

> 
> - Lars
> 
-- 
Damian Hobson-Garcia
IGEL Co.,Ltd
http://www.igel.co.jp
