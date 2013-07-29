Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3G2CMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:12:06 -0400
Received: from [119.145.14.64] ([119.145.14.64]:61302 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3G2CMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:12:01 -0400
Message-ID: <51F5CF04.6080306@huawei.com>
Date: Mon, 29 Jul 2013 10:10:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] tracing: Shrink the size of struct ftrace_event_field
References: <51F08D1B.1080300@huawei.com> <51F08D4B.3010201@huawei.com> <1374851376.6580.34.camel@gandalf.local.home> <51F33F41.9040902@huawei.com> <1374896842.6580.44.camel@gandalf.local.home> <20130727084528.GA6923@pd.tnic>
In-Reply-To: <20130727084528.GA6923@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  static int __trace_define_field(struct list_head *head, const char *type,
>>>  				const char *name, int offset, int size,
>>>  				int is_signed, int filter_type)
>>> @@ -120,13 +123,16 @@ static int __trace_define_field(struct list_head *head, const char *type,
>>>  	field->type = type;
>>>  
>>>  	if (filter_type == FILTER_OTHER)
>>> -		field->filter_type = filter_assign_type(type);
>>> -	else
>>> -		field->filter_type = filter_type;
>>> +		filter_type = filter_assign_type(type);
>>>  
>>> +	field->filter_type = filter_type;
>>>  	field->offset = offset;
>>>  	field->size = size;
>>> -	field->is_signed = is_signed;
>>> +	field->is_signed = !!is_signed;
>>> +
>>> +	VERIFY_SIZE(filter_type);
>>> +	VERIFY_SIZE(offset);
>>> +	VERIFY_SIZE(size);
> 
> Isn't this wrap-a-macro-with-another-more-obscure-macro not a bit too
> much?
> 
> I mean,
>   	WARN_ON(filter_type > field->filter_type)
> 
> is much more readable than VERIFY_SIZE IMO.
> 

Oh, right. Using macro is a bit excessive here.

