Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaAGIts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:49:48 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:50765 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaAGItr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:49:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140106183000.GG1096@mudshark.cambridge.arm.com>
References: <1388420732-13961-1-git-send-email-jean.pihet@linaro.org>
	<1388420732-13961-2-git-send-email-jean.pihet@linaro.org>
	<20140106183000.GG1096@mudshark.cambridge.arm.com>
Date: Tue, 7 Jan 2014 09:49:46 +0100
Message-ID: <CAFrcx1kMkdxemipi7W3pTQZQEfLTsJ0L_X2j8OT1Nf0+Jy+7qg@mail.gmail.com>
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

Hi Will,

On 6 January 2014 19:30, Will Deacon <will.deacon@arm.com> wrote:
> Hi Jean,
>
> Thanks for the updated patches. One minor comment on this one.
Thanks for reviewing!

> On Mon, Dec 30, 2013 at 04:25:30PM +0000, Jean Pihet wrote:
>> From: Jean Pihet <jean.pihet@newoldbits.com>
>>
>> This patch implements the functions required for the perf registers API,
>> allowing the perf tool to interface kernel register dumps with libunwind
>> in order to provide userspace backtracing.
>> Compat mode is also supported.
>
> [...]
>
>> +u64 perf_reg_value(struct pt_regs *regs, int idx)
>> +{
>> +     if (WARN_ON_ONCE((u32)idx >= PERF_REG_ARM64_MAX))
>> +             return 0;
>
> While this is probably fine, I'd feel more comfortable if you had separate
> limit checks for native and compat...
>
>> +     /*
>> +      * Compat (i.e. 32 bit) mode:
>> +      * - PC has been set in the pt_regs struct in kernel_entry,
>> +      * - Handle SP and LR here.
>> +      */
>> +     if (compat_user_mode(regs)) {
>
> i.e. have a WARN_ON_ONCE here for the compat structure size.
>
>> +             if ((u32)idx == PERF_REG_ARM64_SP)
>> +                     return regs->compat_sp;
>> +             if ((u32)idx == PERF_REG_ARM64_LR)
>> +                     return regs->compat_lr;
>> +     }
>
> then stick an else here with the original check.
>
> Make sense?
Yes

I will resend an updated version asap.

>
> Will

Jean
