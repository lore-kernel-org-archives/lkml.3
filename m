Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaEGKT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:19:28 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62586 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaEGKT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:19:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140306123403.5f29c071@gandalf.local.home>
References: <20140303133330.7031b2cb@gandalf.local.home> <1393924179-9147-1-git-send-email-romain.izard.pro@gmail.com>
 <20140306123403.5f29c071@gandalf.local.home>
From: Romain Izard <romain.izard.pro@gmail.com>
Date: Wed, 7 May 2014 12:19:06 +0200
X-Google-Sender-Auth: nxc7pVGxInHMGnWAgWXlm-p8OrM
Message-ID: <CAGkQfmMf0khppOZg6T6sUWcVVHuvbGQr8s3zyogJuqJQcD0HWw@mail.gmail.com>
Subject: Re: [PATCH v2] trace: module: Maintain a valid user count
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-06 18:34 GMT+01:00 Steven Rostedt <rostedt@goodmis.org>:
> Ingo,
>
> You want to push this to Linus?
>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
>
> -- Steve
>
>
> On Tue,  4 Mar 2014 10:09:39 +0100
> Romain Izard <romain.izard.pro@gmail.com> wrote:
>
>> The replacement of the 'count' variable by two variables 'incs' and
>> 'decs' to resolve some race conditions during module unloading was done
>> in parallel with some cleanup in the trace subsystem, and was integrated
>> as a merge.
>>
>> Unfortunately, the formula for this replacement was wrong in the tracing
>> code, and the refcount in the traces was not usable as a result.
>>
>> Use 'count = incs - decs' to compute the user count.
>>
>> Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
>> ---
>>  include/trace/events/module.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
>> index 161932737416..ca298c7157ae 100644
>> --- a/include/trace/events/module.h
>> +++ b/include/trace/events/module.h
>> @@ -78,7 +78,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
>>
>>       TP_fast_assign(
>>               __entry->ip     = ip;
>> -             __entry->refcnt = __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
>> +             __entry->refcnt = __this_cpu_read(mod->refptr->incs) - __this_cpu_read(mod->refptr->decs);
>>               __assign_str(name, mod->name);
>>       ),
>>
>

Ping ?
