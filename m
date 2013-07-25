Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3GYSuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:50:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38309 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab3GYSuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:50:13 -0400
Message-ID: <51F17360.90802@ti.com>
Date: Thu, 25 Jul 2013 14:50:08 -0400
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Jianpeng Ma <majianpeng@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] numa: Mark __node_set as __always_inline
References: <1374754489-4559-1-git-send-email-trini@ti.com> <51F169A7.7030307@gmail.com>
In-Reply-To: <51F169A7.7030307@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 02:08 PM, KOSAKI Motohiro wrote:
> (7/25/13 8:14 AM), Tom Rini wrote:
>> It is posible for some compilers to decide that __node_set does not need
>> to be made turned into an inline function.  When the compiler does this
>> on an __init function calling it on __initdata we get a section mismatch
>> warning now.
>>
>> Reported-by: Paul Bolle <pebolle@tiscali.nl>
>> Cc: Jianpeng Ma <majianpeng@gmail.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Cc: Wen Congyang <wency@cn.fujitsu.com>
>> Cc: Jiang Liu <jiang.liu@huawei.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Greg KH <greg@kroah.com>
>> Signed-off-by: Tom Rini <trini@ti.com>
>> ---
>>   include/linux/nodemask.h |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
>> index 4e2cbfa..10d0fd9 100644
>> --- a/include/linux/nodemask.h
>> +++ b/include/linux/nodemask.h
>> @@ -99,7 +99,7 @@ typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
>>   extern nodemask_t _unused_nodemask_arg_;
>>   
>>   #define node_set(node, dst) __node_set((node), &(dst))
>> -static inline void __node_set(int node, volatile nodemask_t *dstp)
>> +static __always_inline void __node_set(int node, volatile nodemask_t *dstp)
> 
> The change looks ok. But, this code doesn't tell us why you changed. Please write
> down proper comments here.

Done, v2 submitted.

-- 
Tom
