Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3AYQOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:14:20 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63539 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab3AYQOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:14:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130125080656.GB25314@gmail.com>
References: <1356434680-10045-1-git-send-email-festevam@gmail.com>
 <CAOMZO5AzJUvrc5LcNyqPbEz0g4U5KZAXrNK8oJUiht=fdyuc5g@mail.gmail.com>
 <20130124141930.GA14881@gmail.com> <CAOMZO5CC76Md9T=2z3RWi4GrKsUuFcc8VYV1QfmZWF41vnOhVw@mail.gmail.com>
 <20130125071933.GA17846@gmail.com> <CAPM31RKPZeNhUx5OCzE2+Rr=5qSL72=tgRpacZwFos9p-cajAg@mail.gmail.com>
 <20130125080656.GB25314@gmail.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 25 Jan 2013 08:06:56 -0800
Message-ID: <CAPM31RK7txVP9vbDCWFLLshh_98Y-8-T-Vt0C6vZ10Sni4n28g@mail.gmail.com>
Subject: Re: [PATCH v2] sched: Fix print format for u64
To: Ingo Molnar <mingo@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:06 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Paul Turner <pjt@google.com> wrote:
>
>> On Thu, Jan 24, 2013 at 11:19 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Fabio Estevam <festevam@gmail.com> wrote:
>> >
>> >> On Thu, Jan 24, 2013 at 12:19 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> >>
>> >> > I suppose - is this patch warning-free both on 64-bit and 32-bit
>> >> > systems?
>> >>
>> >> Yes, just confirmed that this patch is warning-free on both 64-bit and
>> >> 32-bit machines.
>> >
>> > Apparently it's not all good, see the warning attached below.
>>
>> Yeah this patch is broken; this is not properly fixable as is without
>> #ifdefs (or fixing the insanity that is atomic64_read).
>>
>> Specifically:
>>
>> On some architectures (e.g. x86_64) atomic64_read is typed long
>> On some others (e.g. x86-32) it's typed long long
>> On yet others (e.g. arm) it's typed u64
>
> Hm, cannot we type atomic64_read() to u64 on x86-64 as well, and
> fix other architectures? How widespread is this problem, have
> you checked that perhaps?

I have not looked at how much fall-out this would cause.  Ideally
someone with a cross-compiing tool-chain or from the specific arches
could take ownership of cleaning up their atomic64 implementations to
avoid introducing more build pain.

Theoretically, given the list above x86-64 is actually the outlier in
assuming that it's just a long type; perhaps we can gain sufficient
mileage by changing only the x86-64 implementation; which is much
easier for us to validate :-).

>
> I'm all for clean, consistent types instead of #ifdef or
> temporary variable uglies.

Yes I agree this would be the best solution.

>
> Thanks,
>
>         Ingo
