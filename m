Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3LDIqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:46:13 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62546 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab3LDIqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:46:11 -0500
MIME-Version: 1.0
In-Reply-To: <529EDC14.5070700@hitachi.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
	<CA+b37P3R7r6DoJCX7GQD+BREGsb+s2WBc71c03TVFCPi6=-mkw@mail.gmail.com>
	<529EDC14.5070700@hitachi.com>
Date: Wed, 4 Dec 2013 14:16:09 +0530
Message-ID: <CA+b37P1msx3fSEe_UG=oR458fOoryv=Y_kv5Hg+HzofzgT8KZg@mail.gmail.com>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 December 2013 13:09, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2013/12/04 11:54), Sandeepa Prabhu wrote:
>> On 4 December 2013 06:58, Masami Hiramatsu
>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>> Hi,
>>> Here is the version 4 of NOKPORBE_SYMBOL series.
>>>
>>> In this version, I removed the cleanup patches and
>>> add bugfixes I've found, since those bugs will be
>>> critical.
>>> Rest of the cleanup and visible blacklists will be
>>> proposed later in another series.
>>>
>>> Oh, just one new thing, I added a new RFC patch which
>>> removes the dependency of notify_die() from kprobes
>>> miss-hit/recovery path. Since the notify_die() involves
>>> locking and lockdep code which invokes a lot of heavy
>>> printk functions etc. This helped me to minimize the
>>> blacklist and provides more stability for kprobes.
>>> Actually, most of int3 handlers are already called
>>> from do_int3 directly, I think this change is acceptable
>>> too.
>>>
>>> Here is the updates about NOKPROBE_SYMBOL().
>>>  - Now _ASM_NOKPROBE() macro is introduced for assembly
>>>    symbols on x86.
>>>  - Rename kprobe_blackpoint to kprobe_blacklist_entry
>>>    and simplify it. Also NOKPROBE_SYMBOL() macro just
>>>    saves the address of non-probe-able symbols.
>>>
>>> ---
>>>
>>> Masami Hiramatsu (6):
>>
>>>       kprobes: Prohibit probing on .entry.text code
>>>       kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
>> Hi Masami,
>> Is it good idea to split  "arch/x86" code from generic kernel changes?
>> Then we just need to take above two patches for verifying it on arm64
>> or other platforms.
>
> Yeah, it can be.
> However I think you can apply it without any problem on arm64 tree too,
> since it "just adds" an asm macro in arch/x86/include/asm/asm.h.
> It should not have any effect for other arch. Could you try it? :)
Hmm, for the second patch, git am failed with: "error: patch failed:
kernel/sched/core.c:2662",
manually patched to resolve it.  aarch64 tree is right now at Linux 3.13-rc2.

Anyways, no conflicts for x86 arch files.

Thanks,
Sandeepa

> Thank you,
>
>
> --
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
>
>
