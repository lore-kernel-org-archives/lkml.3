Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3KGWPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:15:12 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:65472 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab3KGWPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:15:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131107213944.GJ1962@tassilo.jf.intel.com>
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
	<527C0195.50008@zytor.com>
	<20131107213944.GJ1962@tassilo.jf.intel.com>
Date: Thu, 7 Nov 2013 23:15:05 +0100
Message-ID: <CAKv+Gu9W-Pu4DGgB-85A3D4Ps9_FLSQgyK3EM7=k7KE1=xsnwg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] wire up CPU features to udev based module loading
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, Steve Capper <steve.capper@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2013 22:39, Andi Kleen <ak@linux.intel.com> wrote:
> On Thu, Nov 07, 2013 at 01:09:41PM -0800, H. Peter Anvin wrote:
>> On 11/07/2013 09:17 AM, Ard Biesheuvel wrote:
>> > This series implements automatic module loading based on optional CPU features,
>> > and tries to do so in a generic way. Currently, 32 feature bits are supported,
>> > and how they map to actual CPU features is entirely up to the architecture.
>>
>> NAK.
>>
>> We in the x86 world already left 32 bits way behind; we currently have
>> 320 bit feature masks.
>>
>> If you're aiming at doing this in a generic way, it needs to be able to
>> accommodate the current x86cpu feature stuff as a subset, which this
>> doesn't.
>
> They can just use the exact same code/macros as x86cpu, just need a different
> prefix and use wildcards if they miss something (e.g. family)
>

That would involve repurposing/generalizing a bit more of the existing
x86-only code than I did the first time around, but if you (as x86
maintainers) are happy with that, I'm all for it.

I do have a couple of questions then
- the module aliases host tool has no arch specific dependencies at
all except having x86cpu as one of the entries: would you mind
dropping the x86 prefix there? Or rather add dependencies on $ARCH?
(If we drop it there, we basically end up with 'cpu:' everywhere)
- in the vendor/family/model case, it may be preferable to drop these
fields entirely from certain modules' aliases if they match on 'any'
(provided that the module tools permit this) rather than add
architecture, variant, revision, etc  fields for all architectures if
they can only ever match on one
- some of the X86_ macros would probable be redefined in terms of the
generic macros rather than the other way around, which would result in
some changes under arch/x86 as well, is that acceptable for you?

Thanks,
Ard.
