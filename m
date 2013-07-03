Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3GCCKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:10:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42362 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3GCCKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:10:23 -0400
Message-ID: <51D3880C.9020503@hitachi.com>
Date: Wed, 03 Jul 2013 11:10:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: [PATCH] tracing/kprobe: Recover old array if fails
 to enable kprobe
References: <51CD25A6.2030907@hitachi.com>  <20130628130452.1132.85665.stgit@mhiramat-M0-7522>  <20130628142744.GA19278@redhat.com>  <1372430586.18733.332.camel@gandalf.local.home>  <20130628184325.GA21822@redhat.com> <51CFE255.6050003@hitachi.com> <1372806135.22688.71.camel@gandalf.local.home>
In-Reply-To: <1372806135.22688.71.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/03 8:02), Steven Rostedt wrote:
> On Sun, 2013-06-30 at 16:46 +0900, Masami Hiramatsu wrote:
>> (2013/06/29 3:43), Oleg Nesterov wrote:
>>> On 06/28, Steven Rostedt wrote:
>>>>
>>>> On Fri, 2013-06-28 at 16:27 +0200, Oleg Nesterov wrote:
>>>>>
>>>>> Ah, but this conflicts with the other changes I sent. They have
>>>>> your acks, and iiuc Steven is going to apply them.
>>>>
>>>> I'll see if I can solve any conflicts. I need to get my -rt versions out
>>>> and start on the new 3.6 stable today. Then after that, I plan on going
>>>> though and getting all the tracing patches settled.
>>>
>>> Thanks!
>>>
>>>>> Besides, this fix is not complete afaics, we should also clear
>>>>> TP_FLAG_TRACE/PROFILE if __enable_trace_probe() fails.
>>>
>>> Yes.
>>>
>>> And I forgot to mention, until we fix the races we discuss in another
>>> thread, this WARN_ON() doesn't look right. So perhaps it would be
>>> really better to delay this change a bit.
>>
>> Agreed, this fix is not a critical one. The racing problem of
>> dynamic events is what we have to solve at first.
>>
> 
> Do you want to reapply this on top of my current for-next branch? Or can
> this wait?

This is a minor one (and must not happen), and AFAICS fixing all the problem
around this requires more works i.e. exporting event_mutex etc.(as I said)
I'll do that asap. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


