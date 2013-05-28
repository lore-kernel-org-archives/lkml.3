Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3E1UOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:14:45 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38169 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab3E1UOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:14:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAL26m8+baBm-kcWH96C1oj3rVHoa0Vc=gHshqWAD-BtBd4FJKQ@mail.gmail.com>
References: <20130526085201.GA3183@udknight> <CAL26m8+baBm-kcWH96C1oj3rVHoa0Vc=gHshqWAD-BtBd4FJKQ@mail.gmail.com>
From: David Sharp <dhsharp@google.com>
Date: Tue, 28 May 2013 13:14:19 -0700
Message-ID: <CAJL_ektFUuXQresgiNoGuDvvGvnF5G8i1wMNG3z8q8aTD4nTUA@mail.gmail.com>
Subject: Re: [PATCH] tracing: Fix file mode of free_buffer
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Wang YanQing <udknight@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:34 PM, Vaibhav Nagarnaik
<vnagarnaik@google.com> wrote:
> On Sun, May 26, 2013 at 1:52 AM, Wang YanQing <udknight@gmail.com> wrote:
>> Commit 4f271a2a60c748599b30bb4dafff30d770439b96
>> (tracing: Add a proc file to stop tracing and free buffer)
>> implement a method to free up ring buffer in kernel memory
>> in the release code path of free_buffer's fd.
>>
>> Then we don't need read/write support for free_buffer,
>> indeed we just have a dummy write fop, and don't implement read fop.
>>
>> So the 0200 is more reasonable file mode for free_buffer than
>> the current file mode 0644.
>>
>> Signed-off-by: Wang YanQing <udknight@gmail.com>
>
> Acked-by: Vaibhav Nagarnaik <vnagarnaik@google.com>

Acked-by: David Sharp <dhsharp@google.com>

>
> Vaibhav Nagarnaik
>
>
>> ---
>>  kernel/trace/trace.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index ae6fa2d..02d9875 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -5927,7 +5927,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
>>         trace_create_file("buffer_total_size_kb", 0444, d_tracer,
>>                           tr, &tracing_total_entries_fops);
>>
>> -       trace_create_file("free_buffer", 0644, d_tracer,
>> +       trace_create_file("free_buffer", 0200, d_tracer,
>>                           tr, &tracing_free_buffer_fops);
>>
>>         trace_create_file("trace_marker", 0220, d_tracer,
>> --
>> 1.7.12.4.dirty
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
