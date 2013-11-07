Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3KGWvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:51:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46350 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab3KGWuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:50:54 -0500
Message-ID: <527C1911.9030900@zytor.com>
Date: Thu, 07 Nov 2013 14:49:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andi Kleen <ak@linux.intel.com>
CC: x86@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, Steve Capper <steve.capper@linaro.org>
Subject: Re: [RFC PATCH 0/4] wire up CPU features to udev based module loading
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>	<527C0195.50008@zytor.com>	<20131107213944.GJ1962@tassilo.jf.intel.com> <CAKv+Gu9W-Pu4DGgB-85A3D4Ps9_FLSQgyK3EM7=k7KE1=xsnwg@mail.gmail.com>
In-Reply-To: <CAKv+Gu9W-Pu4DGgB-85A3D4Ps9_FLSQgyK3EM7=k7KE1=xsnwg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 02:15 PM, Ard Biesheuvel wrote:
> 
> That would involve repurposing/generalizing a bit more of the existing
> x86-only code than I did the first time around, but if you (as x86
> maintainers) are happy with that, I'm all for it.
> 
> I do have a couple of questions then
> - the module aliases host tool has no arch specific dependencies at
> all except having x86cpu as one of the entries: would you mind
> dropping the x86 prefix there? Or rather add dependencies on $ARCH?
> (If we drop it there, we basically end up with 'cpu:' everywhere)

I think it makes sense to indicate what kind of CPU the string refers
to, as the top-level indicator of what is going on.  This might be
possible to macroize the generation of this prefix, though.

> - in the vendor/family/model case, it may be preferable to drop these
> fields entirely from certain modules' aliases if they match on 'any'
> (provided that the module tools permit this) rather than add
> architecture, variant, revision, etc  fields for all architectures if
> they can only ever match on one

I think that can be CPU dependent.

> - some of the X86_ macros would probable be redefined in terms of the
> generic macros rather than the other way around, which would result in
> some changes under arch/x86 as well, is that acceptable for you?

If you are talking about X86_FEATURE_* then almost certainly no,
although I'm willing to listen to what you have in mind.

	-hpa


