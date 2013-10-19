Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3JSOlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 10:41:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59666 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3JSOlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 10:41:11 -0400
MIME-Version: 1.0
In-Reply-To: <20131019141859.GA30765@redhat.com>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
	<20131017224605.2e1d4bab@gandalf.local.home>
	<20131019124312.GA23872@redhat.com>
	<CAGG-pUSk-A=m=cXL85fY+nNgRGQVtG62GouPoANuXFUSrKK6BA@mail.gmail.com>
	<20131019141859.GA30765@redhat.com>
Date: Sat, 19 Oct 2013 11:41:10 -0300
Message-ID: <CAGG-pUTE8prwynzWfwR0+MP4q9UTsKOiWYHM4onhzsrqcTbSMA@mail.gmail.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
 refactors code
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/19 Oleg Nesterov <oleg@redhat.com>:
> On 10/19, Geyslan Gregório Bem wrote:
>>
>> 2013/10/19 Oleg Nesterov <oleg@redhat.com>:
>> > On 10/17, Steven Rostedt wrote:
>> >>
>> >> I'm thinking of just nuking the tracing_open_generic() here. The only
>> >> thing it does here is the tracing_disabled check. The assignment of
>> >> inode->i_private to filp->private_data is pointless
>> >
>> > The same for ftrace_enable_fops() and ftrace_event_filter_fops() at
>> > least. The users of event_file_data() do not use ->private_data.
>> >
>>
>> Aren't "ftrace_enable_fops" and "ftrace_event_filter_fops" structures?
>
> I meant, their ->open() methods.

I see.
>
>> About event_file_data() I think that the callers uses the
>> private_data. So, we have to analyze better.
>
> No, event_file_data() uses ->i_private, filp->private_data is not used.
> And it can't be used, it can point to the already destroyed/freed data.

Ok. I got it.
>
> but, as for seq_open() users,
>
>> static int trace_format_open(struct inode *inode, struct file *file)
>> {
>>     struct seq_file *m;
>>     int ret;
>>
>>     ret = seq_open(file, &trace_format_seq_ops);
>>     if (ret < 0)
>>         return ret;
>>
>>     m = file->private_data;
>>     m->private = file;
>>
>>     return 0;
>> }
>>
>> I really got confused here. The 'm' assignments are, to me, pointless.
>
> I confused too... Why do you think it is pointless?
>
> Just in case, not that after seq_open() ->private_data points to seq_file
> but it is still "void *". And in this case ->private_data has nothing to
> do with ->private_data  set by tracing_open_generic().
>

My bad. I realized it now.
> Oleg.
>

Let's wait Steve's reply about further use of tracing_is_disabled().

Regards.
--Geyslan
