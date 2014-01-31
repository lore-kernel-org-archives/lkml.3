Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbaAaQ5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:57:07 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35156 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaAaQ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:57:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140130220708.GP9951@redhat.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
	<CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
	<52E5EFAF.3060609@linux.intel.com>
	<CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
	<52E601DA.7010605@zytor.com>
	<20140130220708.GP9951@redhat.com>
Date: Fri, 31 Jan 2014 08:57:03 -0800
X-Google-Sender-Auth: ivGUHs3M2RgTmWfjwfqgXLqMqtU
Message-ID: <CAGXu5jKp0j71ucE7uOWRa+gQM1Wzp=_KdByJK4XnACTwiCW4ow@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Kees Cook <keescook@chromium.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
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

On Thu, Jan 30, 2014 at 2:07 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sun, Jan 26, 2014 at 10:51:06PM -0800, H. Peter Anvin wrote:
>> On 01/26/2014 10:49 PM, Richard Weinberger wrote:
>> >>
>> >> No, because that information is available to user space unless we panic.
>> >
>> > Didn't you mean non-root?
>> > I thought one has to set dmesg_restrict anyways if kASLR is used.
>> >
>> > And isn't the offset available to perf too?
>> > Of course only for root, but still user space.
>> >
>>
>> For certain system security levels one want to protect even from a rogue
>> root.  In those cases, leaking that information via dmesg and perf isn't
>> going to work, either.
>>
>> With lower security settings, by all means...
>
> I am wondering if kdump functionality is impacted with this change.
>
> Kexec tools prepares ELF headers for kernel memory ranges and for the
> range where kernel text is mapped. So it needs to know virtual address
> of the region where kernel is mapped (obtained by /proc/kcore) and
> it gets the physical address where kernel is loaded from /proc/iomem.
>
> So with this change are we planning to hide kernel text virtual address and
> physical address information information from root in /proc/kcore and
> /proc/iomem in anyway?

I have no intention of that. Mentioned earlier in the thread, hiding
it from root will be pretty ugly/hard/pointless:
https://lkml.org/lkml/2014/1/27/287
I would like to just keep the offset out of dmesg.

-Kees

-- 
Kees Cook
Chrome OS Security
