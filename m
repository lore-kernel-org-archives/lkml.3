Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaCMSc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:32:58 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:59721 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaCMSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <5321F72E.7030109@zytor.com>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
 <1394664680-17799-4-git-send-email-stefani@seibold.net> <5320E689.7060607@zytor.com>
 <CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com>
 <5321D45C.7040504@zytor.com> <CALCETrVy3oW=qvJWbGtKTZ=0dZLjHtmBphPDnP1N8nLmXc=+9A@mail.gmail.com>
 <5321F418.1030304@zytor.com> <5321F72E.7030109@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Mar 2014 11:32:36 -0700
Message-ID: <CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 11:21 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/13/2014 11:08 AM, H. Peter Anvin wrote:
>> On 03/13/2014 10:28 AM, Andy Lutomirski wrote:
>>>
>>> Does this mean you prefer the relocation approach to the compat vdso
>>> removal approach?  It seems like Linus is okay with either one.
>>>
>>
>> Actually, thinking about it, removing it is probably better:
>>
>> a) gets rid of legacy code, making room for unification;
>> b) either way enabling compat support (either relocation or disabling
>>    the vdso) has a performance penalty for *all* processes.
>>
>> The only way to avoid that is to have a vdso at a fixed addresses across
>> all processes, either in the fixmap or in the user area (presumably at
>> the very top.)
>>
>
> So going back and re-reading all the threads, the consensus was to
> remove the compat vdso, but recycling the CONFIG_COMPAT_VDSO
> configuration option name for the default-disable option.
>

I don't recall anyone suggesting keeping the name.  CONFIG_COMPAT_VDSO
will henceforth be a silly name, since the "compat" mode won't have a
vdso.

The consensus was that the default should be no vdso, right?  My most
recent patchset calls it CONFIG_ENABLE_VDSO32_BY_DEFAULT and defaults
to n.

--Andy

> It is important that anyone who actually cares about performance unsets
> the option.

Should there be a warning at startup if the option is set?

--Andy
