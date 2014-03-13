Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaCMTCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:02:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41831 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbaCMTCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:02:43 -0400
Message-ID: <532200A6.7060608@zytor.com>
Date: Thu, 13 Mar 2014 12:01:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>,
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
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
References: <1394664680-17799-1-git-send-email-stefani@seibold.net> <1394664680-17799-4-git-send-email-stefani@seibold.net> <5320E689.7060607@zytor.com> <CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com> <5321D45C.7040504@zytor.com> <CALCETrVy3oW=qvJWbGtKTZ=0dZLjHtmBphPDnP1N8nLmXc=+9A@mail.gmail.com> <5321F418.1030304@zytor.com> <5321F72E.7030109@zytor.com> <CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com>
In-Reply-To: <CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 11:32 AM, Andy Lutomirski wrote:
> 
> I don't recall anyone suggesting keeping the name.  CONFIG_COMPAT_VDSO
> will henceforth be a silly name, since the "compat" mode won't have a
> vdso.
> 

Linus suggested it:
> What might be acceptable then is to just keep the old config name, and
> if the COMPAT_VDSO config is enabled, you just disable the non-compat
> vdso. At least that way, presumably any opensuse people would have
> their kernel config continue working.

	...

> The consensus was that the default should be no vdso, right?  My most
> recent patchset calls it CONFIG_ENABLE_VDSO32_BY_DEFAULT and defaults
> to n.

On any practical system, the vdso needs to be turned on -- the syscall
performance difference is very significant.

>> It is important that anyone who actually cares about performance unsets
>> the option.
> 
> Should there be a warning at startup if the option is set?

Possibly.  Not sure if anyone will read it.

	-hpa


