Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3CJKkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:40:52 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63656 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CJKkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:40:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHoWGo+B9w-Vmxdv_YWneEqN0U_2cSuvM7H4U67sfFksg@mail.gmail.com>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
	<1362902470-25787-11-git-send-email-jiang.liu@huawei.com>
	<CAOJsxLHoWGo+B9w-Vmxdv_YWneEqN0U_2cSuvM7H4U67sfFksg@mail.gmail.com>
Date: Sun, 10 Mar 2013 12:40:49 +0200
X-Google-Sender-Auth: 5_SjcGJ_FOVZjUDFQvYknWFoFLc
Message-ID: <CAOJsxLGmsLdVxab6HMNXbfbCARna+9e0e4q=PS9nQC+bMXokeg@mail.gmail.com>
Subject: Re: [PATCH v2, part2 10/10] mm/x86: use free_highmem_page() to free
 highmem pages into buddy system
From: Pekka Enberg <penberg@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Cong Wang <amwang@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Attilio Rao <attilio.rao@citrix.com>, konrad.wilk@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 12:32 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sun, Mar 10, 2013 at 10:01 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> Use helper function free_highmem_page() to free highmem pages into
>> the buddy system.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>>  arch/x86/mm/highmem_32.c |    1 -
>>  arch/x86/mm/init_32.c    |   10 +---------
>>  2 files changed, 1 insertion(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
>> index 6f31ee5..252b8f5 100644
>> --- a/arch/x86/mm/highmem_32.c
>> +++ b/arch/x86/mm/highmem_32.c
>> @@ -137,5 +137,4 @@ void __init set_highmem_pages_init(void)
>>                 add_highpages_with_active_regions(nid, zone_start_pfn,
>>                                  zone_end_pfn);
>>         }
>> -       totalram_pages += totalhigh_pages;
>
> Hmm? I haven't looked at what totalram_pages is used for but could you
> explain why this change is safe?

Never mind, I should have read the patchset more carefully:

Reviewed-by: Pekka Enberg <penberg@kernel.org>
