Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3JSAWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:22:03 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41543 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3JSAWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <20131018200951.3636bcf7@gandalf.local.home>
References: <1382129982-9668-1-git-send-email-geyslan@gmail.com>
	<20131018200951.3636bcf7@gandalf.local.home>
Date: Fri, 18 Oct 2013 21:22:01 -0300
Message-ID: <CAGG-pURWPeXhd7OrhH3NnsPSDiS4RoqbB6T83zAo6Gye=PmOew@mail.gmail.com>
Subject: Re: [PATCH 1/2] tracing: creates 'tracing_is_disabled()'
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/18 Steven Rostedt <rostedt@goodmis.org>:
> On Fri, 18 Oct 2013 17:59:41 -0300
> "Geyslan G. Bem" <geyslan@gmail.com> wrote:
>
>> This patch creates the function 'tracing_is_disabled ", which
>> can be used outside trace.c.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  kernel/trace/trace.c | 5 +++++
>>  kernel/trace/trace.h | 1 +
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 7974ba2..a120a73 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -2964,6 +2964,11 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
>>       return 0;
>>  }
>>
>> +inline bool tracing_is_disabled(void)
>
> Nuke the "inline". Gcc and other compilers are smart enough to know to
> inline it on a -O2, that we don't need it. Especially, when it's used
> in another file.
>
> -- Steve

Done. Version 3 sent.

Thanks.
>> +{
>> +     return (tracing_disabled) ? true: false;
>> +}
>> +
>>  /*
>>   * Open and update trace_array ref count.
>>   * Must have the current trace_array passed to it.
>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
