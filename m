Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbaC0VwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 17:52:23 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60547 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbaC0VwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:52:21 -0400
Message-ID: <53349D92.1050907@linaro.org>
Date: Thu, 27 Mar 2014 14:52:18 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Clemens Ladisch <clemens@ladisch.de>, Feng Tang <feng.tang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@sr71.net>
Subject: Re: [PATCH] x86: hpet: Don't default CONFIG_HPET_TIMER to be y for
 X86_64
References: <1395906309-7519-1-git-send-email-feng.tang@intel.com> <53340561.4050708@ladisch.de> <53348199.7070207@mit.edu> <CANcMJZD7PNf-toZ3FyT-NEUs=YnW5ZZ54cCOkziKDb-wZrOoyA@mail.gmail.com> <CALCETrXODB7ifzZQ-DkkxSsHv1HNn3KG5f4sVtyi4pK=nu4ASA@mail.gmail.com>
In-Reply-To: <CALCETrXODB7ifzZQ-DkkxSsHv1HNn3KG5f4sVtyi4pK=nu4ASA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 02:33 PM, Andy Lutomirski wrote:
> On Thu, Mar 27, 2014 at 2:27 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On Thu, Mar 27, 2014 at 12:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On 03/27/2014 04:02 AM, Clemens Ladisch wrote:
>>>> Feng Tang wrote:
>>>> The help text still says:
>>>> | You can safely choose Y here.  [...]
>>>> | Choose N to continue using the legacy 8254 timer.
>>>>
>>>> Are these statements still true for those platforms?
>>> They aren't true for modern desktop and server platforms -- the TSC is
>>> used regardless of hpet availability.
>> While I suspect the comment above is in relation to the non-apic
>> timer. But with respect to timekeeping, our point is true assuming the
>> TSC isn't mucked up by the BIOS.  My 1yr old i7-3930k single socket
>> system still has some wonky BIOS bug that offsets the boot core's TSC.
>> And that's intel's bios, so I can only imagine other vendors have
>> found other ways to cause trouble.
> Is this, perhaps, an MSI X79A-GD65 (8D) (MS-7760)?  If so, there's a fixed BIOS.

Actually, an Intel DX79TO. I've harangued some folks I know, but no
fixes for the BIOS have been released.

>> So yea, the hpet availability for timekeeping is still important, as
>> the TSC can still be problematic.
> Is HPET really that much better than acpi_pm?  I can read my HPET in
> ~584ns (vdso) or ~649ns (syscall) and my acpi_pm in 753ns.  So it's
> better, but not by a whole lot.
I know on older hardware it was a bigger win. I'd have to look at what
my current system does.

> But yes, I see no good reason to disable it, except specifically on
> systems where there are known bugs.
Agreed.

thanks
-john
