Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab3G0DOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:14:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:1808 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3G0DO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:14:29 -0400
Message-ID: <51F33AC9.3040603@huawei.com>
Date: Sat, 27 Jul 2013 11:13:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2][RESEND] tracing: Shrink the size of struct ftrace_event_field
References: <51F08D1B.1080300@huawei.com> <51F08D4B.3010201@huawei.com> <1374851376.6580.34.camel@gandalf.local.home>
In-Reply-To: <1374851376.6580.34.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -111,6 +111,11 @@ static int __trace_define_field(struct list_head *head, const char *type,
>>  	field->size = size;
>>  	field->is_signed = is_signed;
> 
> I think we should just change is_signed to bool. At least the parameter.
> Or we can make the assignment: field->is_signed = !!is_signed; and nuke
> the check below.
> 

Changing field->is_signed to bool won't shrink the size of the struct.
I prefer: field->is_signed = !!is_signed.

>>  
>> +	WARN_ON(offset >= (1 << 12));
>> +	WARN_ON(size >= (1 << 12));
>> +	WARN_ON(is_signed >= (1 << 1));
>> +	WARN_ON(field->filter_type >= (1 << 4));
> 
> Note, the test for field->filter_type is wrong.
> 

oops.

> We should make a helper macro:
> 
> #define VERIFY_SIZE(type) WARN_ON(type > field->type)
> 

Much better!

> and then have:
> 
> 	VERIFY_SIZE(offset);
> 	VERIFY_SIZE(size);
> 	VERIFY_SIZE(filter_type);

