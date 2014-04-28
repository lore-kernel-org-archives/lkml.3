Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaD1CCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:02:16 -0400
Received: from [119.145.14.64] ([119.145.14.64]:42502 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaD1CCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:02:11 -0400
Message-ID: <535DB67A.2020108@huawei.com>
Date: Mon, 28 Apr 2014 10:01:30 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Huxinwei <huxinwei@huawei.com>, Genghui <hui.geng@huawei.com>,
        <jolsa@redhat.com>, <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>, <peifeiyue@huawei.com>
Subject: Re: [PATCH] perf tools: Remove extra '/' character in events file
 path
References: <535B6660.2060001@huawei.com> <87tx9epawt.fsf@sejong.aot.lge.com>
In-Reply-To: <87tx9epawt.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/4/28 8:14, Namhyung Kim 写道:
> Hi xiakaixu,
> 
> (Adding Jiri and Boris to CC)

   OK.
   thanks,
> 
>> The array debugfs_known_mountpoints[] will cause extra '/'
>> character output.
>> Remove it.
>>
>> pre:
>> $ perf probe -l
>> /sys/kernel/debug//tracing/uprobe_events file does not exist -
>> please rebuild kernel with CONFIG_UPROBE_EVENTS.
>>
>> post:
>> $ perf probe -l
>> /sys/kernel/debug/tracing/uprobe_events file does not exist -
>> please rebuild kernel with CONFIG_UPROBE_EVENTS.
> 
> Looks like all of its callers already provide a '/' after the debugfs
> mountpoint, so
> 
>   Acked-by: Namhyung Kim <namhyung@kernel.org>
> 
> Thanks,
> Namhyung
> 
>> 	
>> Signed-off-by: Xia Kaixu <xiakaixu@huawei.com>
>> ---
>>  tools/lib/api/fs/debugfs.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
>> index 7c43479..a74fba6 100644
>> --- a/tools/lib/api/fs/debugfs.c
>> +++ b/tools/lib/api/fs/debugfs.c
>> @@ -12,8 +12,8 @@
>>  char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
>>
>>  static const char * const debugfs_known_mountpoints[] = {
>> -	"/sys/kernel/debug/",
>> -	"/debug/",
>> +	"/sys/kernel/debug",
>> +	"/debug",
>>  	0,
>>  };
>>
>> -- 1.8.5.5
> .
> 


