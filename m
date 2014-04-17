Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaDQXKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:10:19 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:43053 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaDQXKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <53505BD7.9050004@meduna.org>
References: <534C3606.7010206@meduna.org>
	<534C731F.1050406@meduna.org>
	<534DADF1.6060608@meduna.org>
	<53500184.4050309@meduna.org>
	<53505BD7.9050004@meduna.org>
Date: Thu, 17 Apr 2014 19:10:14 -0400
Message-ID: <CAOcfFMyTmQH-FwGE2YWoA76ypzBtWPYVTyi+4QpEMnrRtw8QVg@mail.gmail.com>
Subject: Re: BUG: spinlock trylock failure on UP - reverting timer patches helps
From: jordan <triplesquarednine@gmail.com>
To: Stanislav Meduna <stano@meduna.org>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stano,

On Thu, Apr 17, 2014 at 6:55 PM, Stanislav Meduna <stano@meduna.org> wrote:
> On 17.04.2014 18:29, Stanislav Meduna wrote:
>
>> Note: the bug goes away reverting the very same patches that are
>> helping the Jordan's problms. I did follow
>>
>> http://www.spinics.net/lists/linux-rt-users/msg11639.html
>>
>> and no BUG while booting anymore. I'll try to let it run some
>> more time.

Yeah, i know a handful of people [amd users] that have now reported
success booting into 3.14-rt1 reverting those patches.  Personally, I
have disabled NO_HZ_FULL and have switched back to 'old tick' method
in kconfig. I don't think the latest no_hz stuff is stable enough...

> Erm.. nope
>
> # (cat /proc/meminfo ; cat /proc/meminfo) |  grep KernelStack
> KernelStack:        5920 kB
> KernelStack:        5928 kB
>
> # (cat /proc/meminfo ; cat /proc/meminfo) |  grep KernelStack
> KernelStack:        5952 kB
> KernelStack:        5960 kB
>
> maybe interrupt nesting ad nauseum? How does one debug
> such issues?
>
> It is possible that my previous posting was also caused by this -
> disregard, I'll post again if the problem persists.
>
> Jordan, could you check whether your kernel stack remains
> stable with only the 3 patches reverted?

I'll have to re-install that kernel and get back to you [ give me an
hour or so. i desperately need to eat some food ;) ]. My current
kernel differs in a couple of ways [ but yes, the KernelStack is
stable]. My running/installed rt-kernel is using the 'threadsirq'
patch for linux-rt and isn't vanilla linux-rt anyway, as i patch in
UKSM [in-kernel memory deduplication and BFQ [is scheduler]... but
yes, I'm still reverting those 3 timer[s] patches, since my machine
[and other users i know] won't boot without doing that. Here's my
running kernel's kstack;

[ninez@localhost ~]$  (cat /proc/meminfo ; cat /proc/meminfo) |  grep
KernelStack
KernelStack:        3728 kB
KernelStack:        3728 kB
[ninez@localhost ~]$  (cat /proc/meminfo ; cat /proc/meminfo) |  grep
KernelStack
KernelStack:        3696 kB
KernelStack:        3696 kB

I'll post from my old kernel in a bit.

> Thanks

No problem

Jordan
