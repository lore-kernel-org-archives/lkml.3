Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3LTEms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:42:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44608 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3LTEmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:42:46 -0500
Message-ID: <52B3CABE.1080903@hitachi.com>
Date: Fri, 20 Dec 2013 13:42:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 06/22] [BUGFIX] x86: Prohibit probing on memcpy/memset
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal> <20131219090409.14309.25677.stgit@kbuild-fedora.novalocal> <CAGdX0WFKYHqXrVQ6LBw0YgH_H6cP=LZVCBe1iOvEXsHQPD8Zmg@mail.gmail.com> <52B3AD7D.2020104@hitachi.com> <CAGdX0WENxTPhFDtcEW6LFhk1SNZc6mEK+JsCDOJmfK8_PS1rxg@mail.gmail.com>
In-Reply-To: <CAGdX0WENxTPhFDtcEW6LFhk1SNZc6mEK+JsCDOJmfK8_PS1rxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/20 12:07), Jovi Zhangwei wrote:
> On Fri, Dec 20, 2013 at 10:37 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> Hi Jovi,
>>
>> (2013/12/19 18:37), Jovi Zhangwei wrote:
>>> Hi Masami,
>>>
>>> On Thu, Dec 19, 2013 at 5:04 PM, Masami Hiramatsu
>>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>>> memcpy/memset functions are fundamental functions and
>>>> those are involved in kprobe's exception handling.
>>>> Prohibit probing on them to avoid kernel crash.
>>>>
>>> Would you please let me know the LKML link of that bugfix, I cannot
>>> find it in my LKML fold.
>>
>> Yeah, that was found in my testing environment.
>>
>>> No objection on this patch. :) just want to know more, It seems there
>>> have no problem to probe memcpy in my box, maybe I didn't hit the
>>> crash code path.
>>
>> Ah, I see. Originally the problem happened when I put a probe on
>> __memcpy. And it looks the instances of memcpy and __memcpy are
>> same on x86-64. Thus I decided to blacklist both. (memset/__memset too)
>> Have you ever tried to probe __memcpy on your box?
>>
> Hmm, still no crash, __memcpy and __memset are both tested.
> 
> I use below kprobe related config:
> 
> CONFIG_KPROBES=y
> CONFIG_JUMP_LABEL=y
> CONFIG_OPTPROBES=y
> CONFIG_KPROBES_ON_FTRACE=y

Hmm, I've added some debugging options.

CONFIG_SLUB_DEBUG=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_BOOT_PARAMS=y

I guess some of them might cause it.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


