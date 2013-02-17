Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3BQHjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 02:39:40 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:53999
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438Ab3BQHjj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 02:39:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1155h)
Message-ID: <5120893D.6090705@freescale.com>
Date: Sun, 17 Feb 2013 15:39:41 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: introduce __linear_page_index()
References: <1360047819-6669-1-git-send-email-b32955@freescale.com> <20130205132741.1e1a4e04.akpm@linux-foundation.org>
In-Reply-To: <20130205132741.1e1a4e04.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月06日 05:27, Andrew Morton 写道:
> On Tue, 5 Feb 2013 15:03:39 +0800
> Huang Shijie<b32955@freescale.com>  wrote:
>
>> +static inline pgoff_t __linear_page_index(struct vm_area_struct *vma,
>>   					unsigned long address)
>>   {
>>   	pgoff_t pgoff;
>> +
>> +	pgoff = (address - vma->vm_start)>>  PAGE_SHIFT;
>> +	return pgoff + vma->vm_pgoff;
>> +}
>> +
>> +static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
>> +					unsigned long address)
>> +{
>>   	if (unlikely(is_vm_hugetlb_page(vma)))
>>   		return linear_hugepage_index(vma, address);
>> -	pgoff = (address - vma->vm_start)>>  PAGE_SHIFT;
>> -	pgoff += vma->vm_pgoff;
>> -	return pgoff>>  (PAGE_CACHE_SHIFT - PAGE_SHIFT);
>> +	return __linear_page_index(vma, address)>>
>> +				(PAGE_CACHE_SHIFT - PAGE_SHIFT);
>>   }
> I don't think we need bother creating both linear_page_index() and
> __linear_page_index().  Realistically, we won't be supporting
Just as Hocko said, the unmap_ref_private() (in hugetlb.c) may also uses 
the __linear_page_index().
So it's better to the two helpers : linear_page_index() and 
__linear_page_index().
do you agree?

thanks
Huang Shijie

