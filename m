Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbbAEXFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:05:19 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:45447 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbbAEXFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:05:15 -0500
MIME-Version: 1.0
In-Reply-To: <54AAFFA3.6000901@linux.intel.com>
References: <cover.1419900414.git.luto@amacapital.net> <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
 <54A64E6D.1020304@linux.intel.com> <87mw5x0xjz.fsf@tassilo.jf.intel.com> <54AAFFA3.6000901@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Jan 2015 15:04:53 -0800
Message-ID: <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API to arch_prctl
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 1:18 PM, Dave Hansen <dave.hansen@linux.intel.com> wrote:
> On 01/05/2015 12:42 PM, Andi Kleen wrote:
>> Dave Hansen <dave.hansen@linux.intel.com> writes:
>>> On 12/29/2014 04:52 PM, Andy Lutomirski wrote:
>>>> This has the benefit the it avoids cluttering prctl with more
>>>> arch-specific functionality.  The down side is that arch_prctl will
>>>> need to be wired up as a 32-bit syscall to add 32-bit support for
>>>> MPX.
>>>
>>> There is existing userspace out there which depends on the existing
>>> prctl() setup.  There isn't a _lot_ and it might still be able to be
>>> changed easily, but this isn't a given.
>>>
>>> I'll check in with the folks doing the gcc (runtime) part of this next
>>> week and see what they think.
>>
>> It'll be quite messy for 32bit because they would need to use syscall(),
>> as glibc won't have a arch_prctl stub.

We should avoid arch_prctl because glibc won't add a syscall stub that
libgcc or whatever would want?  My mind boggles.

>
> Yeah, I'd _really_ prefer not to change it.  The code is in a gcc
> branch, but is getting pulled in to the 5.0 release.  We've got
> *absolutely* no shortage of prctl numbers.

We do, however, have a severe shortage of sanity in the prctl implementation.

Anyway, if it's actually a problem to change it, I have no real
problem keeping it, but I think we *really* need to validate the rest
of the arguments at the very least.

--Andy
