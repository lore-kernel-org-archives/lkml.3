Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaAPPvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:51:14 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32789 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaAPPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:51:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAPp3RGpWhx4uoTTiSkUe9rZ2iJjMW6O2u=xdWL7BSskse=61qw@mail.gmail.com>
References: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
	<CAPp3RGpWhx4uoTTiSkUe9rZ2iJjMW6O2u=xdWL7BSskse=61qw@mail.gmail.com>
Date: Thu, 16 Jan 2014 09:51:09 -0600
Message-ID: <CAPp3RGonDThdAAr4c3FVowVHWhE02fHJTG5MH=QbJBNVfgx5Pg@mail.gmail.com>
Subject: Re: [PATCH] mm/nobootmem: Fix unused variable
From: Robin Holt <robinmholt@gmail.com>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, liuj97@gmail.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, robin.m.holt@gmail.com, yinghai@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh.  Thought I had changed that to plain text mode before sending.

Sorry for the noise,
Robin


On Thu, Jan 16, 2014 at 9:45 AM, Robin Holt <robinmholt@gmail.com> wrote:
>
> I can not see how this works.  How is the return from
> get_allocated_memblock_reserved_regions_info() stored and used without being
> declared?  Maybe you are working off a different repo than Linus' latest?  Your line
> 116 is my 114.  Maybe the message needs to be a bit more descriptive and
> certainly the bit after the '---' should be telling me what this is applying against.
>
> Robin
>
>
> On Thu, Jan 16, 2014 at 7:33 AM, Philipp Hachtmann <phacht@linux.vnet.ibm.com> wrote:
>>
>> This fixes an unused variable warning in nobootmem.c
>>
>> Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
>> ---
>>  mm/nobootmem.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
>> index e2906a5..12cbb04 100644
>> --- a/mm/nobootmem.c
>> +++ b/mm/nobootmem.c
>> @@ -116,9 +116,13 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>>  static unsigned long __init free_low_memory_core_early(void)
>>  {
>>         unsigned long count = 0;
>> -       phys_addr_t start, end, size;
>> +       phys_addr_t start, end;
>>         u64 i;
>>
>> +#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
>> +       phys_addr_t size;
>> +#endif
>> +
>>         for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
>>                 count += __free_memory_core(start, end);
>>
>> --
>> 1.8.4.5
>>
>
