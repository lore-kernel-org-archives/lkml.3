Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaLGNx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 08:53:58 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50244 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaLGNx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 08:53:56 -0500
Date: Sun, 07 Dec 2014 21:53:47 +0800
Subject: Re: [PATCH] mm: memcontrol: Skip test_mem_cgroup_node_reclaimable()
 when no MAX_NUMNODES or not more than 1
Message-ID: <51ggckac0utecg6rqx48nkmc.1417960383505@email.android.com>
From: Chen Gang <gang.chen.5i5j@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org,
        " linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB7Ds5VV020846

OK, thanks. I shall try to send another patch to upstream kernel
within this month.

Send from Lenovo A788t.

Michal Hocko <mhocko@suse.cz> wrote:

>Hi,
>this has been fixed last week already
>http://marc.info/?l=linux-mm&m=141751847710864&w=2
>
>On Sat 06-12-14 06:27:57, Chen Gang wrote:
>> test_mem_cgroup_node_reclaimable() is only used when "MAX_NUMNODES > 1",
>> so move it into related quote.
>> 
>> The related warning (with allmodconfig under parisc):
>> 
>>     CC      mm/memcontrol.o
>>   mm/memcontrol.c:1629:13: warning: 'test_mem_cgroup_node_reclaimable' defined but not used [-Wunused-function]
>>    static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
>>                ^
>> 
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  mm/memcontrol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index c6ac50e..d538b08 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1616,6 +1616,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>  			 NULL, "Memory cgroup out of memory");
>>  }
>>  
>> +#if MAX_NUMNODES > 1
>>  /**
>>   * test_mem_cgroup_node_reclaimable
>>   * @memcg: the target memcg
>> @@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
>>  	return false;
>>  
>>  }
>> -#if MAX_NUMNODES > 1
>>  
>>  /*
>>   * Always updating the nodemask is not very good - even if we have an empty
>> -- 
>> 1.9.3
>
>-- 
>Michal Hocko
>SUSE Labs
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
