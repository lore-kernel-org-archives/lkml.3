Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbbAEXXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:23:02 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:62621 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbbAEXXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:23:00 -0500
MIME-Version: 1.0
In-Reply-To: <54AB19EC.4020401@linux.intel.com>
References: <cover.1419900414.git.luto@amacapital.net> <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
 <54A64E6D.1020304@linux.intel.com> <87mw5x0xjz.fsf@tassilo.jf.intel.com>
 <54AAFFA3.6000901@linux.intel.com> <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
 <54AB19EC.4020401@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Jan 2015 15:22:39 -0800
Message-ID: <CALCETrWA5p3rzu1SM8Avt7oXm-B=mxfRhEJuOUw-ND+7upn+SQ@mail.gmail.com>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API to arch_prctl
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 3:10 PM, Dave Hansen <dave.hansen@linux.intel.com> wrote:
> On 01/05/2015 03:04 PM, Andy Lutomirski wrote:
>>> > Yeah, I'd _really_ prefer not to change it.  The code is in a gcc
>>> > branch, but is getting pulled in to the 5.0 release.  We've got
>>> > *absolutely* no shortage of prctl numbers.
>> We do, however, have a severe shortage of sanity in the prctl implementation.
>>
>> Anyway, if it's actually a problem to change it, I have no real
>> problem keeping it, but I think we *really* need to validate the rest
>> of the arguments at the very least.
>
> Do you mean just adding a pair of
>
>         if (arg2 || arg3 || arg4 || arg5)
>                 return -EINVAL;
>
> checks?

Exactly.

Thanks,
Andy

>
> That's perfectly fine with me.  I'm happy to queue up a patch to do just
> that if that's what you're going for.



-- 
Andy Lutomirski
AMA Capital Management, LLC
