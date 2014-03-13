Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaCMTfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:35:53 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:46206 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaCMTfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwDn3zA0gEn2r3nJVPWuv-pLYyrj4=8_gt1xFTd2g_Dwg@mail.gmail.com>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
 <1394664680-17799-4-git-send-email-stefani@seibold.net> <5320E689.7060607@zytor.com>
 <CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com>
 <5321D45C.7040504@zytor.com> <CALCETrVy3oW=qvJWbGtKTZ=0dZLjHtmBphPDnP1N8nLmXc=+9A@mail.gmail.com>
 <5321F418.1030304@zytor.com> <5321F72E.7030109@zytor.com> <CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com>
 <CA+55aFyOp6V_tE-sXKVi+=6yVwHQb0sLWSNbk=N7KbhBrx9QhA@mail.gmail.com>
 <CA+55aFyCSL==4Ff4JT3uFKN_28mz92ef1L67-4OUGqHZ8HXUhg@mail.gmail.com>
 <CALCETrVa2XPc5JBDbDdH1ciavi2tuqwBf7picE4TVf69n_PcKw@mail.gmail.com> <CA+55aFwDn3zA0gEn2r3nJVPWuv-pLYyrj4=8_gt1xFTd2g_Dwg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Mar 2014 12:35:30 -0700
Message-ID: <CALCETrWaTPnC2xc1UOgYjbc4CFnZb1kTLLnit5rj8fnGsabcEQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Andi Kleen <ak@linux.intel.com>, John Stultz <john.stultz@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:21 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mar 13, 2014 12:13 PM, "Andy Lutomirski" <luto@amacapital.net> wrote:
>>
>> How?  We either set null in AT_SYSINFO_EHDR, we set something simple
>> that SuSE is okay with (and compile separate images?) or we set
>> something fancy and not relocated, and SuSE crashes.
>
> Yeah, I was thinking that "something simple is the fixmap space that suse
> would be happy with"
>
> Keyword being "simple", ie so simple that it's not a maintenance headache
> even if it's different from the "real" vdso.
>
> But I suspect we don't really need it.

I agree.  Also, the syscall instruction selection is currently rather
complicated, and I don't think it can ever be *that* simple :(

>
>> On a related note: is it okay to keep the option called
>> CONFIG_COMPAT_VDSO but change the default to n?
>
> Yes. If you start from scratch with a config, you have to get the options
> right. It's just the "I upgraded the kernel, did an oldconfig, and it
> doesn't work" case that we should avoid.
>
> The alternative would be to make a new config name, but then it has to
> default to the compatible state (iow no vdso at all by default), because
> that's the rule: make oldconfig should work for people.
>
> Basically, kernel upgrades should be nobrainers and "just work".

OK.  I'll send out new patches.

--Andy
