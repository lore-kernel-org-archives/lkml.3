Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaB0UMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:12:15 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45557 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaB0UMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:12:13 -0500
MIME-Version: 1.0
In-Reply-To: <530ECBB1.40806@zytor.com>
References: <cover.1393462777.git.luto@amacapital.net> <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net>
 <20140227033920.GI12219@tassilo.jf.intel.com> <530EC7D1.3000706@zytor.com>
 <CALCETrWbS3B_63Q76E5RL0Y6B=1=1ObmECR3HTMk1HQ-4OwN8A@mail.gmail.com> <530ECBB1.40806@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Feb 2014 12:11:52 -0800
Message-ID: <CALCETrWXO8zxvjbT9usjghkM_MEzGOa9_18x7xXPcOOPYeXijA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: Mark __vdso entries as asmlinkage
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>, Stefani Seibold <stefani@seibold.net>,
        X86 ML <x86@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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

On Wed, Feb 26, 2014 at 9:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/26/2014 09:19 PM, Andy Lutomirski wrote:
>>>
>>> The normal ABI almost certainly makes more sense; as such -mregparm=3 is
>>> probably not what we want, and I suspect it makes more sense to just
>>> drop that from the CFLAGS line?
>>
>> Hmm.  What happens on a native 32-bit build?  IIRC the whole kernel is
>> build with regparm(3).
>>
>
> Well, the vdso is still built separately, so we can use different CFLAGS
> if we want to.
>
>> If we want to save a cycle or two, then regparm(3) is probably faster.
>>  But I think that these functions should either be asmlinkage or (on
>> 32 bit builds) explicitly regparm(3) to avoid confusion.
>
> I suggest using the standard ABI, but I suggest doing it via CFLAGS.

Hmm.  This sort of goes against existing x86_32 practice where,
AFAICT, things that need a particular calling convention specify
asmlinkage and everything else uses regparm(3) if config/kbuild thinks
it's appropriate.

But I'm happy to resubmit the patch if you prefer the CFLAGS approach
for the 32-bit vdso.  I don't think anything will break, since I don't
think that the 32-bit vdso has any other exported C code.

>
> It isn't any faster if the C library has to provide a wrapper just to
> marshal parameters.

Probably true, given that the glibc wrapper could, in principle, use
an optimized tail call.  Also, I see no reason why vdso functions,
alone of all userspace code, should be special.

--Andy
