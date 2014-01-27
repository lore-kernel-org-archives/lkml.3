Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaA0RF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:05:28 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61784 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaA0RF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:05:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
	<CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
	<52E5EFAF.3060609@linux.intel.com>
	<CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
Date: Mon, 27 Jan 2014 09:05:25 -0800
X-Google-Sender-Auth: 3RCo1B-xZzeFBouDxh5PjDP1F-E
Message-ID: <CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Kees Cook <keescook@chromium.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 10:49 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Mon, Jan 27, 2014 at 6:33 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> On 01/26/2014 02:16 AM, Richard Weinberger wrote:
>>>
>>> Currently we print the kernel offset only upon a panic() using the
>>> panic notifier list.
>>> This way it does not show up if the kernel hits a BUG() in process
>>> context or something less critical.
>>> Wouldn't make more sense to report the offset in every dump_stack() or
>>> show_regs() call?
>>
>> No, because that information is available to user space unless we panic.
>
> Didn't you mean non-root?
> I thought one has to set dmesg_restrict anyways if kASLR is used.
>
> And isn't the offset available to perf too?
> Of course only for root, but still user space.

Setting dmesg_restrict is done mostly in an effort to try to lock down
access to dmesg since it'll likely contain enough clues to help an
attacker. System owners need to avoid dmesg getting sprayed into
/var/log world-readable, or available via privileged debugging
daemons, etc. Since keeping dmesg secret from non-root users is going
to be error-prone, I had a goal of keeping the offset out of dmesg
while the system is still running -- hence doing it only at panic
time.

Finding the offset as the (unconfined) root user is extremely easy, so
I personally see no reason to hide it from root (and it would be very
irritating for things like perf, too). I view kASLR as a tool for
statistical defense against confined processes or remote attacks.

I would argue that decoding a non-panic oops on a running system is
entirely possible as-is, since the offset can be found from
/proc/kallsyms as root. It was the dead system that needed the offset
exported: via text in the panic, or via an ELF note in a core.

-Kees

-- 
Kees Cook
Chrome OS Security
