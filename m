Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaLVId2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 03:33:28 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49122 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaLVId1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 03:33:27 -0500
Message-ID: <5497D750.2040104@hitachi.com>
Date: Mon, 22 Dec 2014 17:33:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Divya Vyas <edivya.vyas@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Merge ftrace data of host and guest
References: <CAGfiMvCLgdaACWuUJAWecaLP9cSZRLFzzWgNGoiZTidT9m60cg@mail.gmail.com> <20141220051008.GE5474@home.goodmis.org> <CAGfiMvB8tH30MGKz2XQ6ugZjrBxRmYUSiBb-_bOwzGr8mFCbiA@mail.gmail.com> <CAGfiMvBOTm2EH5R1W8AwWWxTROX8hO=YH78fJm=Ljo4H7btkKA@mail.gmail.com>
In-Reply-To: <CAGfiMvBOTm2EH5R1W8AwWWxTROX8hO=YH78fJm=Ljo4H7btkKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on trace-cmd virt-server feature. This is just a basic feature
to allow trace-cmd using virtio-trace (no time synchronizing).
I'll send the updated version of the series soon.

(2014/12/22 16:07), Divya Vyas wrote:
> Hi ,
> 
> One more thing I want to add that Yoshihiro YUNOMAE's  trace-merge
> script does this time synchronization. We have to calculate guest
> offset and then subtract with host time .

Right, to complete this work we need trace-merge like merging feature.
I assume that we can do that by passing the offset of the timestamp
information with guest trace data (that is the simplest implementation).

However, currently trace-merge depends on x86 TSC, but some intel
processors TSC is not stable. That is current barrier of trace-merge.

Thank you,


> 
> But it is not applying on current trace-cmd report output format and
> not giving desired output .
> 
> Thanks,
> Divya Vyas
> 
> On Mon, Dec 22, 2014 at 12:34 PM, Divya Vyas <edivya.vyas@gmail.com> wrote:
>> Hi Steven,
>>
>> I am sorry but I am very new to trace-cmd , that's why I didn't knew
>> what you are working on it.
>>
>> I will explain you whole scenario , Actually I have multiple guests
>> and a host and I want to see all traces on a single file  with
>> trace-cmd report command and may be kernelshark also .
>>
>> trace-cmd report -i guest.dat -i host.dat command is giving me all
>> traces is single file but the timestamp is different for guest . So
>> the challenge for me is to sync the timestamp of guest and host .  Can
>> you advise me something in this ? How can I sync gettimeofday clocks
>> of guest and host ?
>>
>> and kernelshark doesnt take trace-cmd report input , I think it takes
>> guest.dat and host.dat .
>> Is there any other viewer available for ftrace ?
>>
>>
>>
>>
>>
>>
>> On Sat, Dec 20, 2014 at 10:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> On Fri, Dec 19, 2014 at 05:52:52PM +0530, Divya Vyas wrote:
>>>> Hi,
>>>
>>> Hi, it would be  helpful if you Cc'd me. I would have responded quicker. Luckily,
>>> someone noticed this email and told me about it.
>>>
>>>>
>>>> I think it is not desired output . Ths script is written for diffrent
>>>> format .ftrace format is ( trace-cmd report command generates) :
>>>
>>> I'm actually working on trace-cmd this week and hopefully I'll be able to release
>>> 2.5 by x-mas.
>>>
>>> I believe that Masami is going to start continuing work on the virt guest
>>> tracer for trace-cmd.
>>>
>>> Also, for now, for a crud way of merging, if both the gettimeofday clocks
>>> of the host and guest are synced, you could do:
>>>
>>> guest> trace-cmd record -o guest.dat --date  ...
>>>
>>> host> trace-cmd record -o host.dat --date ...
>>>
>>> and then run:
>>>
>>> trace-cmd report -i guest.dat -i host.dat
>>>
>>> and trace-cmd will merge the two. The --date will add a way to sync the trace
>>> timestamps to a wall clock and that will be used to try to interleave the
>>> events of both the data files.
>>>
>>> -- Steve
>>>
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


