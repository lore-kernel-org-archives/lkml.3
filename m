Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaJJBD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 21:03:28 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52074 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaJJBD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 21:03:26 -0400
Message-ID: <54373056.7070001@hitachi.com>
Date: Fri, 10 Oct 2014 10:03:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: Re: [PATCH ftrace/for-next v5 0/5] ftrace, kprobes: Introduce
 IPMODIFY flag for ftrace_ops to detect conflicts
References: <20141009130059.4698.21616.stgit@kbuild-f20.novalocal> <20141009112157.17a52571@gandalf.local.home>
In-Reply-To: <20141009112157.17a52571@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/10 0:21), Steven Rostedt wrote:
> On Thu, 09 Oct 2014 13:00:59 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Hi,
>>
>> Here is the 5th version of the series of patches which introduces
>> IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
>> who can modify regs->ip in their handler.
>>
>> The previous version is here;
>>  https://lkml.org/lkml/2014/7/28/13
>>
>> This version is basically an update of previous version to the
>> latest ftrace tree, and adding a test code to selftest.
>>
>> Currently, only kprobes can change the regs->ip in the handler,
>> but recently kpatch is also want to change it. Moreover, since
>> the ftrace itself exported to modules, it might be considerable
>> senario.
>>
>> Here we talked on github.
>>  https://github.com/dynup/kpatch/issues/47
>>
>> To protect modified regs-ip from each other, this series
>> introduces FTRACE_OPS_FL_IPMODIFY flag and ftrace now ensures
>> the flag can be set on each function entry location. If there
>> is someone who already reserve regs->ip on target function
>> entry, ftrace_set_filter_ip or register_ftrace_function will
>> return -EBUSY. Users must handle that.
>> The ftrace_ops with IPMODIFY flag requires at least one
>> entry for filter hash, and its notrace_hash must be empty,
>> because the IPMODIFY action is very address sensitve and
>> user must consider the ip address.
>>
>> The 3rd patch adds a special reservation of IPMODIFY on the
>> jprobed address, since it is the only user who will change
>> the regs->ip. Other kprobes do not change it anymore. 
>>
>> Thank you,
>>
> 
> Masami,
> 
> Thanks for sending this. I'm going to look at it after Dusseldorf. It's
> too late to get it into 3.18, but it looks like a good fit for the work
> I have for 3.19.

Yeah, I think there is no problem until someone tries to use
both ftrace and jprobe on the same target.

> Just don't let me forget you sent this :-)  Even though I tagged it as
> important, I'm sure I'll be tagging a lot of other emails as important
> in the next week.

OK, I'll ping after the event.

> Also, my main test box has finally died. I ordered a new motherboard
> (thanks Linus for the suggestion!) and unfortunately it is due to
> arrive tomorrow. That's the same day I leave and I don't trust my wife
> to install it for me ;-)

Oh, that is a bad timing...

> This means I can not do my tests that I like to run before adding to
> linux-next.

OK, so see you in next week :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


