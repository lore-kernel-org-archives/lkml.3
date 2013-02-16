Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab3BPDou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 22:44:50 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:3648 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3BPDos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 22:44:48 -0500
Message-ID: <511EFFA5.6000306@huawei.com>
Date: Sat, 16 Feb 2013 11:40:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Namhyung Kim <namhyung@kernel.org>, Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
References: <20130207094650.76302f47@riff.lan> <20130207185608.GA25223@gmail.com> <20130207191345.GA28960@gmail.com> <20130207195257.GA29985@gmail.com> <20130207150838.02226207@riff.lan> <20130208141841.GB30334@gmail.com> <20130208085828.02e61518@riff.lan> <20130211095457.GF23932@gmail.com> <87d2w5ovc0.fsf@sejong.aot.lge.com> <20130213091512.GC7630@gmail.com>
In-Reply-To: <20130213091512.GC7630@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/13 17:15, Ingo Molnar wrote:
> 
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
>> Hi,
>>
>> On Mon, 11 Feb 2013 10:54:58 +0100, Ingo Molnar wrote:
>>> * Clark Williams <williams@redhat.com> wrote:
>>>
>>>> I figured that was coming. :)
>>>
>>> ;-)
>>>
>>>> I'll look at it again and see about pulling the 
>>>> autogroup/cgroup stuff into it's own header. After that it's 
>>>> probably going to require some serious changes.
>>>>
>>>> Any suggestions?
>>>
>>> I'd suggest doing it as finegrained as possible - potentially 
>>> one concept at a time. I wouldn't mind a dozen small files in 
>>> include/linux/sched/ - possibly more.
>>
>> What about the .c files?  AFAICS the sched/core.c and 
>> sched/fair.c are rather huge and contain various concepts 
>> which might be separated to their own files.  It'd be better 
>> reorganizing them too IMHO.
> 
> I'd be more careful about those, because there's various 
> scheduler patch-sets floating modifying them.
> 
> sched.h is much more static and it is the one that actually gets 
> included in like 60% of all *other* .c files, adding a few 
> thousand lines to every .o compilation and causing measurable 
> compile time overhead ...
> 
> So sched.h splitting is something we should really do, if 
> there's people interested in and capable of pulling it off.
> 

While previously working on a cgroup patchset that also touched sched.h,
I noticed some lines can be moved to kernel/sched/sched.h. I've cooked
up a patchset to do that, and it results in reduction of 200+ lines in
sched.h. I'll do some compile testing before sending it out.

