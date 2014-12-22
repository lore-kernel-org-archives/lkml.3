Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaLVHIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:08:14 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:51894 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaLVHIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:08:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAGfiMvB8tH30MGKz2XQ6ugZjrBxRmYUSiBb-_bOwzGr8mFCbiA@mail.gmail.com>
References: <CAGfiMvCLgdaACWuUJAWecaLP9cSZRLFzzWgNGoiZTidT9m60cg@mail.gmail.com>
 <20141220051008.GE5474@home.goodmis.org> <CAGfiMvB8tH30MGKz2XQ6ugZjrBxRmYUSiBb-_bOwzGr8mFCbiA@mail.gmail.com>
From: Divya Vyas <edivya.vyas@gmail.com>
Date: Mon, 22 Dec 2014 12:37:52 +0530
Message-ID: <CAGfiMvBOTm2EH5R1W8AwWWxTROX8hO=YH78fJm=Ljo4H7btkKA@mail.gmail.com>
Subject: Re: Merge ftrace data of host and guest
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

One more thing I want to add that Yoshihiro YUNOMAE's  trace-merge
script does this time synchronization. We have to calculate guest
offset and then subtract with host time .

But it is not applying on current trace-cmd report output format and
not giving desired output .

Thanks,
Divya Vyas

On Mon, Dec 22, 2014 at 12:34 PM, Divya Vyas <edivya.vyas@gmail.com> wrote:
> Hi Steven,
>
> I am sorry but I am very new to trace-cmd , that's why I didn't knew
> what you are working on it.
>
> I will explain you whole scenario , Actually I have multiple guests
> and a host and I want to see all traces on a single file  with
> trace-cmd report command and may be kernelshark also .
>
> trace-cmd report -i guest.dat -i host.dat command is giving me all
> traces is single file but the timestamp is different for guest . So
> the challenge for me is to sync the timestamp of guest and host .  Can
> you advise me something in this ? How can I sync gettimeofday clocks
> of guest and host ?
>
> and kernelshark doesnt take trace-cmd report input , I think it takes
> guest.dat and host.dat .
> Is there any other viewer available for ftrace ?
>
>
>
>
>
>
> On Sat, Dec 20, 2014 at 10:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Fri, Dec 19, 2014 at 05:52:52PM +0530, Divya Vyas wrote:
>>> Hi,
>>
>> Hi, it would be  helpful if you Cc'd me. I would have responded quicker. Luckily,
>> someone noticed this email and told me about it.
>>
>>>
>>> I think it is not desired output . Ths script is written for diffrent
>>> format .ftrace format is ( trace-cmd report command generates) :
>>
>> I'm actually working on trace-cmd this week and hopefully I'll be able to release
>> 2.5 by x-mas.
>>
>> I believe that Masami is going to start continuing work on the virt guest
>> tracer for trace-cmd.
>>
>> Also, for now, for a crud way of merging, if both the gettimeofday clocks
>> of the host and guest are synced, you could do:
>>
>> guest> trace-cmd record -o guest.dat --date  ...
>>
>> host> trace-cmd record -o host.dat --date ...
>>
>> and then run:
>>
>> trace-cmd report -i guest.dat -i host.dat
>>
>> and trace-cmd will merge the two. The --date will add a way to sync the trace
>> timestamps to a wall clock and that will be used to try to interleave the
>> events of both the data files.
>>
>> -- Steve
>>
