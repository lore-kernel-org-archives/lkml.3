Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaFLU6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:58:03 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:40259 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaFLU6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:58:01 -0400
MIME-Version: 1.0
In-Reply-To: <539A0DC2.1010203@zytor.com>
References: <1402602419-27934-1-git-send-email-keescook@chromium.org>
	<539A0422.9010000@zytor.com>
	<CAGXu5jLvAr=f2MRP4Ni86-jbM7h3Mx3RQo=7coveE8ZEt12N=Q@mail.gmail.com>
	<539A0DC2.1010203@zytor.com>
Date: Thu, 12 Jun 2014 13:58:00 -0700
X-Google-Sender-Auth: fT7a0aMU527cZVF9FB-AcZECcIk
Message-ID: <CAGXu5jKanRjK66P9dFYctXfQxT+da_9z8vqy8s+WqgW1cw17-Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 1:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/12/2014 01:27 PM, Kees Cook wrote:
>>>
>>> Any way we can make them work together instead?
>>
>> I'm sure there is, but I don't know the solution. :)
>>
>> At the very least this gets us one step closer (we can build them together).
>>
>
> But it is really invasive.

Well, I don't agree there. I actually would like to be able to turn
off hibernation support on distro kernels regardless of kASLR, so I
think this is really killing two birds with one stone.

> I have to admit to being somewhat fuzzy on what the core problem with
> hibernation and kASLR is... in both cases there is a set of pages that
> need to be installed, some of which will overlap the loader kernel.
> What am I missing?

I don't know how resume works, but I have assumed that the newly
loaded kernel stays in memory and pulls in the vmalloc, kmalloc,
modules, and userspace memory maps from disk. Since these things can
easily contain references to kernel text, if the newly loaded kernel
has moved with regard to the hibernated image, everything breaks.
IIUC, this is similar why you can't rebuild your kernel and resume
from a different version.

Potential solutions might be to do some kind of kexec-ish second
kernel load that puts it in the "right" place, based on what's stored
in the on-disk image. It sounds extremely non-trivial, and isn't
something I will have time to work on in the foreseeable future.

Making them both build together, however, that I can do. :)

-Kees

-- 
Kees Cook
Chrome OS Security
