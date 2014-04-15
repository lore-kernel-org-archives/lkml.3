Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaDOAOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:14:51 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40757 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaDOAOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:14:50 -0400
Message-ID: <534C79EE.3030505@gmail.com>
Date: Tue, 15 Apr 2014 08:14:38 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, akpm@linux-foundation.org,
        liuj97@gmail.com, rientjes@google.com, dhowells@redhat.com,
        mhocko@suse.cz, mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFtQQVRDSF0gYXJjaDp1bmljb3JlMzI6bW06IGE=?=
 =?UTF-8?B?ZGQgZGV2bWVtX2lzX2FsbG93ZWQoKSB0byBzdXBwb3J0IFNUUklDVF9ERVZNRU0=?=
References: <629583968.18592.1396927216694.JavaMail.root@bj-mail03.pku.edu.cn> <534380F6.7090703@gmail.com>
In-Reply-To: <534380F6.7090703@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We got no-reply almost a week, so we can assume "can put the code into
"asm/io.h" as static inline function".

I will/should send patch v2 for it.

Thanks.

On 04/08/2014 12:54 PM, Chen Gang wrote:
> 
> On 04/08/2014 11:20 AM, 管雪涛 wrote:
>> I'd like to put the code into asm/io.h, and make it static.
>>
> 
> It sounds OK to me, but I don't know why the other architectures (e.g.
> arm, powerpc, x86) put them into ".c".
> 
> iomem_is_exclusive() and page_is_ram() are all extern functions, so for
> me, devmem_is_allowed() is shot enough to be as inline function.
> 
>>> +#ifdef CONFIG_STRICT_DEVMEM
>>> +/*
>>> + * devmem_is_allowed() checks to see if /dev/mem access to a certain
>>> + * address is valid. The argument is a physical page number.
>>> + * We mimic x86 here by disallowing access to system RAM as well as
>>> + * device-exclusive MMIO regions. This effectively disable read()/write()
>>> + * on /dev/mem.
>>> + */
>>> +static int devmem_is_allowed(unsigned long pfn)
> 
> How about "static inline int devmem_is_allowed(unsigned long pfn)"?
> 
>>> +{
>>> +	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
>>> +		return 0;
>>> +	if (!page_is_ram(pfn))
>>> +		return 1;
>>> +	return 0;
>>> +}
>>> +#endif /* CONFIG_STRICT_DEVMEM */
>>
>> Thanks,
>>
>> Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
>>
> 
> [...]
> 
> Thanks.
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
