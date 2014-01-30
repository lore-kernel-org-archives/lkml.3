Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaA3R54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:57:56 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:62600 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaA3R5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:57:55 -0500
MIME-Version: 1.0
In-Reply-To: <1391097131.2898.5.camel@wall-e.seibold.net>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
 <52EA704D.2000809@zytor.com> <1391097131.2898.5.camel@wall-e.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Jan 2014 09:57:34 -0800
Message-ID: <CALCETrVaKxY22=4S=mWhUgQ--H77kqnay5G8f847H=Cfper86w@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add 32 bit VDSO time function support
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 7:52 AM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Donnerstag, den 30.01.2014, 07:31 -0800 schrieb H. Peter Anvin:
>> On 01/30/2014 02:49 AM, stefani@seibold.net wrote:
>> > The VDSO page for a 32 bit resided now on 0xffffc000, followed by the VVAR and
>> > HPET page.
>>
>> Any reason to not move the vdso base page to the top, in order to avoid
>> breaking broken applications?  It seems a fairly innocuous shuffle...
>> probably little gain, but very little cost.
>>
>>       -hpa
>>
>
> The reason is that i get need than an additional VMA for HPET and VVAR.
>
> I seen no break of applications since the __FIXADDR_TOP is not on a fix
> place. Lguest, XEN, OPLC and the reservetop Kernel Parameter will change
> the VDSO Page Address.

By definition there aren't any broken users of the new functions,
because there aren't any users at all.  So... should we start
randomizing this thing from the beginning?

Also, since the VVAR page has a real vma, should something be done to
prevent mprotect or ptrace from COWing it?  Users will be rather
surprised if it suddenly stops updating.

Finally, this might be the time to kill off the userspace mapping of
the HPET.  I suspect that there are few if any machines for which the
HPET is fast enough that avoiding a syscall matters at all.  (On my
box at work, reading the HPET takes ~500 nanoseconds.  I can do a lot
of syscalls in that amount of time.)

>
> - Stefani
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
