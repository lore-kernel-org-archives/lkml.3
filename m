Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaA3SEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:04:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58027 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbaA3SEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:04:33 -0500
Message-ID: <52EA93E4.6010504@zytor.com>
Date: Thu, 30 Jan 2014 10:03:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Stefani Seibold <stefani@seibold.net>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 0/4] Add 32 bit VDSO time function support
References: <1391078953-1575-1-git-send-email-stefani@seibold.net> <52EA704D.2000809@zytor.com> <1391097131.2898.5.camel@wall-e.seibold.net> <CALCETrVaKxY22=4S=mWhUgQ--H77kqnay5G8f847H=Cfper86w@mail.gmail.com>
In-Reply-To: <CALCETrVaKxY22=4S=mWhUgQ--H77kqnay5G8f847H=Cfper86w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 09:57 AM, Andy Lutomirski wrote:
> 
> By definition there aren't any broken users of the new functions,
> because there aren't any users at all.  So... should we start
> randomizing this thing from the beginning?
> 

The vdso already exists.  It isn't new.  Randomizing it might be a good
idea, though; it already is randomized on 64 bits.

> Also, since the VVAR page has a real vma, should something be done to
> prevent mprotect or ptrace from COWing it?  Users will be rather
> surprised if it suddenly stops updating.

What happens currently on 64 bits?  I think we just take the attitude
that "don't do that, then", and it hasn't seemed to be a problem.

> Finally, this might be the time to kill off the userspace mapping of
> the HPET.  I suspect that there are few if any machines for which the
> HPET is fast enough that avoiding a syscall matters at all.  (On my
> box at work, reading the HPET takes ~500 nanoseconds.  I can do a lot
> of syscalls in that amount of time.)

I think this can be independent of extending the current 64-bit
functionality to 32 bits.  It is a valid question, though.

	-hpa

