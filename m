Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3BAD5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:57:52 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:30661 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3BAD5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:57:51 -0500
Message-ID: <510B3D2A.3040007@huawei.com>
Date: Fri, 1 Feb 2013 11:57:30 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Kent Overstreet <koverstreet@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/4] Export blk_fill_rwbs()
References: <1358285142-10576-1-git-send-email-koverstreet@google.com>  <1358285142-10576-3-git-send-email-koverstreet@google.com> <1359690521.5642.10.camel@gandalf.local.home>
In-Reply-To: <1359690521.5642.10.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2013/2/1 11:48, Steven Rostedt wrote:
> Li,
> 
> Can you give an Ack or Nack for this.
> 

I think this patch shouldn't go into upstream without bcache code. We don't
export symbols for out of tree code.

> Thanks,
> 
> -- Steve
> 
> 
> On Tue, 2013-01-15 at 13:25 -0800, Kent Overstreet wrote:
>> Exported so it can be used by bcache's tracepoints
>>
>> Signed-off-by: Kent Overstreet <koverstreet@google.com>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> CC: Frederic Weisbecker <fweisbec@gmail.com>
>> CC: Ingo Molnar <mingo@redhat.com>
>> ---
>>  kernel/trace/blktrace.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
>> index c0bd030..dbe1667 100644
>> --- a/kernel/trace/blktrace.c
>> +++ b/kernel/trace/blktrace.c
>> @@ -1806,6 +1806,7 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
>>  
>>  	rwbs[i] = '\0';
>>  }
>> +EXPORT_SYMBOL_GPL(blk_fill_rwbs);
>>  
>>  #endif /* CONFIG_EVENT_TRACING */
>>  
> 
> 
> 

