Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab3CYJK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:10:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42989 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab3CYJK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:10:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,344,1363104000"; 
   d="scan'208";a="6939521"
Message-ID: <5150151E.7070206@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 17:13:02 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org
CC: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        penberg@kernel.org, jacob.shin@amd.com
Subject: Re: [PATCH] x86: mm: add_pfn_range_mapped: use meaningful index to
 teach clean_sort_range()
References: <1363602093-11965-1-git-send-email-linfeng@cn.fujitsu.com> <CAE9FiQUHtM_Nuz4ak+HeNGV6a-HTtfMkxc+zBZuow47Vj70CKQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUHtM_Nuz4ak+HeNGV6a-HTtfMkxc+zBZuow47Vj70CKQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 17:10:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 17:10:09,
	Serialize complete at 2013/03/25 17:10:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 03/19/2013 02:52 AM, Yinghai Lu wrote:
> On Mon, Mar 18, 2013 at 3:21 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
>> Since add_range_with_merge() return the max none zero element of the array, it's
>> suffice to use it to instruct clean_sort_range() to do the sort. Or the former
>> assignment by add_range_with_merge() is nonsense because clean_sort_range()
>> will produce a accurate number of the sorted array and it never depends on
>> nr_pfn_mapped.
>>
>> Cc: Jacob Shin <jacob.shin@amd.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>> ---
>>  arch/x86/mm/init.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index 59b7fc4..55ae904 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -310,7 +310,7 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
>>  {
>>         nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
>>                                              nr_pfn_mapped, start_pfn, end_pfn);
>> -       nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
>> +       nr_pfn_mapped = clean_sort_range(pfn_mapped, nr_pfn_mapped);
>>
>>         max_pfn_mapped = max(max_pfn_mapped, end_pfn);>
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Do we need to pick up this patch?

thanks,
linfeng
