Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab3LXGjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 01:39:37 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:55821 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3LXGjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 01:39:32 -0500
MIME-Version: 1.0
In-Reply-To: <52B8178F.5020607@hitachi.com>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
	<20131219090409.14309.25677.stgit@kbuild-fedora.novalocal>
	<CAGdX0WFKYHqXrVQ6LBw0YgH_H6cP=LZVCBe1iOvEXsHQPD8Zmg@mail.gmail.com>
	<52B3AD7D.2020104@hitachi.com>
	<CAGdX0WENxTPhFDtcEW6LFhk1SNZc6mEK+JsCDOJmfK8_PS1rxg@mail.gmail.com>
	<52B3CABE.1080903@hitachi.com>
	<CAGdX0WEev84sOyu-uzkDOmQFi_=mza7cPzyC0VkRZe0fD_1+jQ@mail.gmail.com>
	<52B40C00.2060401@hitachi.com>
	<CAGdX0WECaJBSX29-+fC=0XLJfAh0JvFyLTW2V8yM616L45iCQQ@mail.gmail.com>
	<52B8178F.5020607@hitachi.com>
Date: Tue, 24 Dec 2013 14:39:29 +0800
Message-ID: <CAGdX0WEZue1fBtHw058HAmuCktkM+jyKdPfn0ZM2=fNAPfcJwA@mail.gmail.com>
Subject: Re: Re: Re: [PATCH -tip v6 06/22] [BUGFIX] x86: Prohibit probing on memcpy/memset
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 6:59 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2013/12/23 13:51), Jovi Zhangwei wrote:
>> On Fri, Dec 20, 2013 at 5:21 PM, Masami Hiramatsu
>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>> (2013/12/20 17:31), Jovi Zhangwei wrote:
>>>> On Fri, Dec 20, 2013 at 12:42 PM, Masami Hiramatsu
>>>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>> (2013/12/20 12:07), Jovi Zhangwei wrote:
>>>>>> On Fri, Dec 20, 2013 at 10:37 AM, Masami Hiramatsu
>>>>>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>>>> Hi Jovi,
>>>>>>>
>>>>>>> (2013/12/19 18:37), Jovi Zhangwei wrote:
>>>>>>>> Hi Masami,
>>>>>>>>
>>>>>>>> On Thu, Dec 19, 2013 at 5:04 PM, Masami Hiramatsu
>>>>>>>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>>>>>> memcpy/memset functions are fundamental functions and
>>>>>>>>> those are involved in kprobe's exception handling.
>>>>>>>>> Prohibit probing on them to avoid kernel crash.
>>>>>>>>>
>>>>>>>> Would you please let me know the LKML link of that bugfix, I cannot
>>>>>>>> find it in my LKML fold.
>>>>>>>
>>>>>>> Yeah, that was found in my testing environment.
>>>>>>>
>>>>>>>> No objection on this patch. :) just want to know more, It seems there
>>>>>>>> have no problem to probe memcpy in my box, maybe I didn't hit the
>>>>>>>> crash code path.
>>>>>>>
>>>>>>> Ah, I see. Originally the problem happened when I put a probe on
>>>>>>> __memcpy. And it looks the instances of memcpy and __memcpy are
>>>>>>> same on x86-64. Thus I decided to blacklist both. (memset/__memset too)
>>>>>>> Have you ever tried to probe __memcpy on your box?
>>>>>>>
>>>>>> Hmm, still no crash, __memcpy and __memset are both tested.
>>>>>>
>>>>>> I use below kprobe related config:
>>>>>>
>>>>>> CONFIG_KPROBES=y
>>>>>> CONFIG_JUMP_LABEL=y
>>>>>> CONFIG_OPTPROBES=y
>>>>>> CONFIG_KPROBES_ON_FTRACE=y
>>>>>
>>>>> Hmm, I've added some debugging options.
>>>>>
>>>>> CONFIG_SLUB_DEBUG=y
>>>>> CONFIG_X86_DEBUGCTLMSR=y
>>>>> CONFIG_PNP_DEBUG_MESSAGES=y
>>>>> CONFIG_DEBUG_INFO=y
>>>>> CONFIG_DEBUG_FS=y
>>>>> CONFIG_DEBUG_KERNEL=y
>>>>> CONFIG_DEBUG_STACK_USAGE=y
>>>>> CONFIG_DEBUG_MEMORY_INIT=y
>>>>> CONFIG_DEBUG_STACKOVERFLOW=y
>>>>> CONFIG_DEBUG_SPINLOCK=y
>>>>> CONFIG_DEBUG_MUTEXES=y
>>>>> CONFIG_DEBUG_LOCK_ALLOC=y
>>>>> CONFIG_DEBUG_LOCKDEP=y
>>>>> CONFIG_DEBUG_BUGVERBOSE=y
>>>>> CONFIG_DEBUG_RODATA=y
>>>>> CONFIG_DEBUG_BOOT_PARAMS=y
>>>>>
>>>>> I guess some of them might cause it.
>>>>>
>>>> I recompiled the kernel with those config enabled, unfortunately still no crash,
>>>> I tested on 3.13.0-rc4, a fedora kvm box.
>>>
>>> Hmm, it's very odd. I'm running 3.13.0-rc4 x86-64 on the fedora
>>> kvm box too. here is the full of my kconfig.
>>>
>> That configuration is still working for me, no crash for memcpy kprobe test.
>
> Would you do __memcpy test? or memcpy test? I only had a crash on the
> __memcpy(__memset).
>
Still no crash, use your kernel config.
memcpy and __memcpy have same address in /proc/kallsyms.

Looks like a interesting problem.

Thanks,

Jovi.
