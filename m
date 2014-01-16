Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaAPOtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:49:40 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:48815 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaAPOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:49:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140115110724.GB3571@mudshark.cambridge.arm.com>
References: <1388420732-13961-1-git-send-email-jean.pihet@linaro.org>
	<1388420732-13961-2-git-send-email-jean.pihet@linaro.org>
	<20140106183000.GG1096@mudshark.cambridge.arm.com>
	<CAFrcx1=ivcoNBTSBO47zs04Ji3XZza7pH3bVFS5M0-uZTg38RA@mail.gmail.com>
	<20140115110724.GB3571@mudshark.cambridge.arm.com>
Date: Thu, 16 Jan 2014 15:49:37 +0100
Message-ID: <CAFrcx1nN5hnhOWWxKP7TOOh4bGMtBcD_aK8T6_8mYW7HJRTZEQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM64: perf: add support for perf registers API
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jean Pihet <jean.pihet@newoldbits.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On 15 January 2014 12:07, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Jan 15, 2014 at 10:30:48AM +0000, Jean Pihet wrote:
>> Hi Will,
>
> Hi Jean,
>
>> On 6 January 2014 19:30, Will Deacon <will.deacon@arm.com> wrote:
>> > On Mon, Dec 30, 2013 at 04:25:30PM +0000, Jean Pihet wrote:
>> >> From: Jean Pihet <jean.pihet@newoldbits.com>
>> >>
>> >> This patch implements the functions required for the perf registers API,
>> >> allowing the perf tool to interface kernel register dumps with libunwind
>> >> in order to provide userspace backtracing.
>> >> Compat mode is also supported.
>> >
>> > [...]
>> >
>> >> +u64 perf_reg_value(struct pt_regs *regs, int idx)
>> >> +{
>> >> +     if (WARN_ON_ONCE((u32)idx >= PERF_REG_ARM64_MAX))
>> >> +             return 0;
>> >
>> > While this is probably fine, I'd feel more comfortable if you had separate
>> > limit checks for native and compat...
>> In fact in the native and compat modes the same set of registers are
>> accessed, based on the native regs that are registered to the perf
>> event core, cf. the definition of PERF_REGS_MASK in
>> tools/perf/arch/arm64/include/perf_regs.h.
>>
>> The regs set could be registered differently based on the binary to
>> trace, but unfortunately the perf core code does not allow that.
>>
>> I would leave the code as is, what do you think?
>
> Well, what business would a compat task have accessing registers beyond the
> compat subset? Since we don't expose the PC, we can simply lower the limit
> as the compat registers form a prefix of the native registers, no?
Yes it is a good thing to clamp the range of registers, based on the
compat mode.
Unfortunately the perf core code does not handle the compat mode,
instead it always accesses all _native_ registers.

Here is the proposal (after our discussion on IRC):
- use the current patches on ARM64 so that we have a working solution
that one can test/stress/use on real workloads,
- re-factor the perf core code later to make able to handle multiple
ABIs and corresponding registers sets.

Are you ok with that?

Regards,
Jean

>
> Will
