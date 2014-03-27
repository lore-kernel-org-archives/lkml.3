Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbaC0V12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 17:27:28 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36328 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbaC0V10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:27:26 -0400
MIME-Version: 1.0
In-Reply-To: <53348199.7070207@mit.edu>
References: <1395906309-7519-1-git-send-email-feng.tang@intel.com>
	<53340561.4050708@ladisch.de>
	<53348199.7070207@mit.edu>
Date: Thu, 27 Mar 2014 14:27:26 -0700
X-Google-Sender-Auth: 9wK9LseDGyvaLQ27UwDFUj9eZeo
Message-ID: <CANcMJZD7PNf-toZ3FyT-NEUs=YnW5ZZ54cCOkziKDb-wZrOoyA@mail.gmail.com>
Subject: Re: [PATCH] x86: hpet: Don't default CONFIG_HPET_TIMER to be y for X86_64
From: John Stultz <john.stultz@linaro.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Clemens Ladisch <clemens@ladisch.de>, Feng Tang <feng.tang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 12:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 03/27/2014 04:02 AM, Clemens Ladisch wrote:
>> Feng Tang wrote:
>> The help text still says:
>> | You can safely choose Y here.  [...]
>> | Choose N to continue using the legacy 8254 timer.
>>
>> Are these statements still true for those platforms?
>
> They aren't true for modern desktop and server platforms -- the TSC is
> used regardless of hpet availability.

While I suspect the comment above is in relation to the non-apic
timer. But with respect to timekeeping, our point is true assuming the
TSC isn't mucked up by the BIOS.  My 1yr old i7-3930k single socket
system still has some wonky BIOS bug that offsets the boot core's TSC.
And that's intel's bios, so I can only imagine other vendors have
found other ways to cause trouble.

So yea, the hpet availability for timekeeping is still important, as
the TSC can still be problematic.

thanks
-john
