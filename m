Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbbAVKKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:10:05 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:49052 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbAVKJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:09:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAGfiMvA_K+r=p_G+PJ0SJdTqwZw3NBDtNO0=+we8x6-a6+ugPg@mail.gmail.com>
References: <CAGfiMvCLgdaACWuUJAWecaLP9cSZRLFzzWgNGoiZTidT9m60cg@mail.gmail.com>
 <20141220051008.GE5474@home.goodmis.org> <CAGfiMvB8tH30MGKz2XQ6ugZjrBxRmYUSiBb-_bOwzGr8mFCbiA@mail.gmail.com>
 <CAGfiMvBOTm2EH5R1W8AwWWxTROX8hO=YH78fJm=Ljo4H7btkKA@mail.gmail.com>
 <5497D750.2040104@hitachi.com> <CAGfiMvAALjFU+5FdmXa1VTQM6ZeEAZG5F1VDO60BRx4EK9zMZQ@mail.gmail.com>
 <CAGfiMvCQrcwsdDxM5XJtX=BZOF+LbpRJJgLCYEGTRNKkUioK9g@mail.gmail.com> <CAGfiMvA_K+r=p_G+PJ0SJdTqwZw3NBDtNO0=+we8x6-a6+ugPg@mail.gmail.com>
From: Divya Vyas <edivya.vyas@gmail.com>
Date: Thu, 22 Jan 2015 15:39:23 +0530
Message-ID: <CAGfiMvBgwd6A59-4jgcf0qm+bMEz3h-_WOdCJpum3guF8Oe_Eg@mail.gmail.com>
Subject: Re: Merge ftrace data of host and guest
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on merge of ftrace data of guest and host .

tsc_guest = tsc_host +offset

I got offset from /sys/kernel/debug/tracing/instances/tsc_offset/trace
 18446739224709377060

Where as my guest and host data is in below format :

 sshd-2332  [000]  4813.363939: net_dev_queue:        dev=eth0
skbaddr=0xffff88003b78f6e8 len=134
 sshd-2332  [000]  4813.363951: net_dev_xmit:         dev=eth0
skbaddr=0xffff88003b78f6e8 len=134 rc=0
 sshd-2332  [000]  4813.364010: netif_receive_skb:    dev=eth0
skbaddr=0xffff880015cbbc00 len=52
 sshd-2332  [000]  4813.364042: net_dev_queue:        dev=eth0
skbaddr=0xffff88002c086ce8 len=102
 sshd-2332  [000]  4813.364053: net_dev_xmit:         dev=eth0
skbaddr=0xffff88002c086ce8 len=102 rc=0
 trace-cmd-2496  [000]  4813.364098: netif_receive_skb:    dev=eth0
skbaddr=0xffff880015cbbc00 len=52
 <idle>-0     [000]  4814.384570: netif_receive_skb:    dev=eth0
skbaddr=0xffff88003a490a00 len=38
 <idle>-0     [000]  4816.384541: netif_receive_skb:    dev=eth0
skbaddr=0xffff88003a490900 len=38
 <idle>-0     [000]  4818.384681: netif_receive_skb:    dev=eth0
skbaddr=0xffff88003a490900 len=38

How can I add the timestamp and offset .Do I need to add directly the numbers ?



On Tue, Jan 13, 2015 at 11:03 AM, Divya Vyas <edivya.vyas@gmail.com> wrote:
> Hi,
>
> Is there any feature in ftrace like synchronizing the timestamp
>
> http://help.eclipse.org/luna/index.jsp?topic=%2Forg.eclipse.linuxtools.lttng.help%2Fdoc%2FTrace-synchronization.html
>
>
>
> On Wed, Jan 7, 2015 at 2:57 PM, Divya Vyas <edivya.vyas@gmail.com> wrote:
>> Hi Masami,
>>
>> Any updates on the merge feature?
>>
>>
>>
>> On Mon, Dec 22, 2014 at 4:36 PM, Divya Vyas <edivya.vyas@gmail.com> wrote:
>>> Hi Masami,
>>>
>>> Thanks for the patches .
>>>
>>> Are you working on this merging feature also
>>> https://lkml.org/lkml/2013/12/16/688 ? the d option ?
>>>
>>> trace-cmd report -i will not give expected output if the time is not
>>> synchronized . From kernel side we can get TSC offset  using
>>> tracepoint when guest boots . I think this tracepoint was added from
>>> 3.11  but from user side I got only the trace-merge script which takes
>>> offset and trace and host data .  But the format of trace data this
>>> script accepts is little different .
>>>
>>> My end goal is to to merge the traces in chronological order and see
>>> them in kernelshark .
>>>
>>>
>>> Thanks,
>>> Divya
>>>
>>>
>>>
>>>
>>>
>>> On Mon, Dec 22, 2014 at 2:03 PM, Masami Hiramatsu
>>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>>> Hi,
>>>>
>>>> I'm working on trace-cmd virt-server feature. This is just a basic feature
>>>> to allow trace-cmd using virtio-trace (no time synchronizing).
>>>> I'll send the updated version of the series soon.
>>>>
>>>> (2014/12/22 16:07), Divya Vyas wrote:
>>>>> Hi ,
>>>>>
>>>>> One more thing I want to add that Yoshihiro YUNOMAE's  trace-merge
>>>>> script does this time synchronization. We have to calculate guest
>>>>> offset and then subtract with host time .
>>>>
>>>> Right, to complete this work we need trace-merge like merging feature.
>>>> I assume that we can do that by passing the offset of the timestamp
>>>> information with guest trace data (that is the simplest implementation).
>>>>
>>>> However, currently trace-merge depends on x86 TSC, but some intel
>>>> processors TSC is not stable. That is current barrier of trace-merge.
>>>>
>>>> Thank you,
>>>>
>>>>
>>>>>
>>>>> But it is not applying on current trace-cmd report output format and
>>>>> not giving desired output .
>>>>>
>>>>> Thanks,
>>>>> Divya Vyas
>>>>>
>>>>> On Mon, Dec 22, 2014 at 12:34 PM, Divya Vyas <edivya.vyas@gmail.com> wrote:
>>>>>> Hi Steven,
>>>>>>
>>>>>> I am sorry but I am very new to trace-cmd , that's why I didn't knew
>>>>>> what you are working on it.
>>>>>>
>>>>>> I will explain you whole scenario , Actually I have multiple guests
>>>>>> and a host and I want to see all traces on a single file  with
>>>>>> trace-cmd report command and may be kernelshark also .
>>>>>>
>>>>>> trace-cmd report -i guest.dat -i host.dat command is giving me all
>>>>>> traces is single file but the timestamp is different for guest . So
>>>>>> the challenge for me is to sync the timestamp of guest and host .  Can
>>>>>> you advise me something in this ? How can I sync gettimeofday clocks
>>>>>> of guest and host ?
>>>>>>
>>>>>> and kernelshark doesnt take trace-cmd report input , I think it takes
>>>>>> guest.dat and host.dat .
>>>>>> Is there any other viewer available for ftrace ?
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> On Sat, Dec 20, 2014 at 10:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>>>>>> On Fri, Dec 19, 2014 at 05:52:52PM +0530, Divya Vyas wrote:
>>>>>>>> Hi,
>>>>>>>
>>>>>>> Hi, it would be  helpful if you Cc'd me. I would have responded quicker. Luckily,
>>>>>>> someone noticed this email and told me about it.
>>>>>>>
>>>>>>>>
>>>>>>>> I think it is not desired output . Ths script is written for diffrent
>>>>>>>> format .ftrace format is ( trace-cmd report command generates) :
>>>>>>>
>>>>>>> I'm actually working on trace-cmd this week and hopefully I'll be able to release
>>>>>>> 2.5 by x-mas.
>>>>>>>
>>>>>>> I believe that Masami is going to start continuing work on the virt guest
>>>>>>> tracer for trace-cmd.
>>>>>>>
>>>>>>> Also, for now, for a crud way of merging, if both the gettimeofday clocks
>>>>>>> of the host and guest are synced, you could do:
>>>>>>>
>>>>>>> guest> trace-cmd record -o guest.dat --date  ...
>>>>>>>
>>>>>>> host> trace-cmd record -o host.dat --date ...
>>>>>>>
>>>>>>> and then run:
>>>>>>>
>>>>>>> trace-cmd report -i guest.dat -i host.dat
>>>>>>>
>>>>>>> and trace-cmd will merge the two. The --date will add a way to sync the trace
>>>>>>> timestamps to a wall clock and that will be used to try to interleave the
>>>>>>> events of both the data files.
>>>>>>>
>>>>>>> -- Steve
>>>>>>>
>>>>>
>>>>
>>>>
>>>> --
>>>> Masami HIRAMATSU
>>>> Software Platform Research Dept. Linux Technology Research Center
>>>> Hitachi, Ltd., Yokohama Research Laboratory
>>>> E-mail: masami.hiramatsu.pt@hitachi.com
>>>>
>>>>
