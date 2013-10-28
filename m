Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab3J1Py3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:54:29 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62027 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3J1Py1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <20131028121747.GL19466@laptop.lan>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
	<1382533085-7166-4-git-send-email-eranian@google.com>
	<20131025111422.GC1219@krava.redhat.com>
	<CABPqkBR0gEz7cauev0hk=oofO1m9RP=wP3NK3j0y7EiNE8j3tg@mail.gmail.com>
	<CABPqkBShxTc3wBkwWej6gaWJK3GmdtV71hNdozabnbwpesXx_A@mail.gmail.com>
	<20131028121747.GL19466@laptop.lan>
Date: Mon, 28 Oct 2013 16:54:26 +0100
Message-ID: <CABPqkBTtMyxA4-n0ExQ5Q0HjwW94h_qiON--92n2SVyHZ4E2fw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Mon, Oct 28, 2013 at 1:17 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Oct 28, 2013 at 11:33:50AM +0100, Stephane Eranian wrote:
>> If we have that, then it may not be necessary anymore
>> to express the raw count in the 1/2^32 J unit like we
>> are currently doing. This loses a bit of precision. We
>> could as well expose the actual raw count and export
>> the actual unit via sysfs. For instance, on SNB/IVB the
>> unit is 1/2^16, but on Haswell it is 1/2^14.
>
> 2^-32 can losslessly express both 2^-16 and 2^-14.
>
> Notably: 2^18/2^32 = 2^(18-32) = 2^-14.
>
> So no, 2^-32 does not loose precision.
>
You are correct. No bits are lost.

> The only side effect of always using 2^-32 is that we can only maximally
> represent 2^32 (from 64-32), whereas when using 2^-14 we could maximally
> represent 2^50.
>
> That said; 2^32 Joule ~ 4.2 GJ which is a rather large quantity of
> energy; one I would hope is out there when measuring package energy
> costs over any reasonable amount of time.
>
> So the only reason to switch away from using the 32.32 fixed point would
> be if someone can make a reasonable argument for why 4.2 GJ is not
> sufficient and they need 1 PJ (yes, peta-joule, as in we need a private
> nuclear reactor to power this CPU).

I think we are fine with what we have. Simple, no precision lost, constant
user-visible scaling factor easy to export as a string to user tools. Comparison
of raw count possible directly.

I will post v4 very soon.
Thanks.
