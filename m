Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaCMTNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:13:39 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:40600 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaCMTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyCSL==4Ff4JT3uFKN_28mz92ef1L67-4OUGqHZ8HXUhg@mail.gmail.com>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
 <1394664680-17799-4-git-send-email-stefani@seibold.net> <5320E689.7060607@zytor.com>
 <CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com>
 <5321D45C.7040504@zytor.com> <CALCETrVy3oW=qvJWbGtKTZ=0dZLjHtmBphPDnP1N8nLmXc=+9A@mail.gmail.com>
 <5321F418.1030304@zytor.com> <5321F72E.7030109@zytor.com> <CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com>
 <CA+55aFyOp6V_tE-sXKVi+=6yVwHQb0sLWSNbk=N7KbhBrx9QhA@mail.gmail.com> <CA+55aFyCSL==4Ff4JT3uFKN_28mz92ef1L67-4OUGqHZ8HXUhg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Mar 2014 12:13:17 -0700
Message-ID: <CALCETrVa2XPc5JBDbDdH1ciavi2tuqwBf7picE4TVf69n_PcKw@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Andi Kleen <ak@linux.intel.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On my phone, so the lists will reject this, and sorry for top posting.
>
> Maybe we could do something similar to the vsyscall=native thing, where the
> compat vdso just does the system calls, but at least uses syscall rather
> than int80 when appropriate? Make the suse situation not suck horribly...

How?  We either set null in AT_SYSINFO_EHDR, we set something simple
that SuSE is okay with (and compile separate images?) or we set
something fancy and not relocated, and SuSE crashes.

At least for the 64-bit vsyscall case, modern code is polite enough to
completely ignore the vsyscall page.  Unfortunately, modern 32-bit
glibc looks at the exact same AT_SYSINFO_EHDR.

If the syscall overhead is that bad, the dynamic relocation approach
might be better...

On a related note: is it okay to keep the option called
CONFIG_COMPAT_VDSO but change the default to n?  The assumption is
that everyone with OpenSUSE already has a working config, but new
defconfig users will get the better choice?

--Andy
