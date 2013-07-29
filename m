Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3G2KjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:39:18 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60294 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3G2KjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130729095400.GB32383@mudshark.cambridge.arm.com>
References: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org>
	<CAKfTPtBpo41LJ3V8TB8YwudwqpURuA2u_Lvu4KYVK=qSs+gFuQ@mail.gmail.com>
	<20130729095400.GB32383@mudshark.cambridge.arm.com>
Date: Mon, 29 Jul 2013 12:39:16 +0200
Message-ID: <CAKfTPtANkeZkDHP_b2OV=tRxQ+q-J_SVMzrMYifgEhiJy=GijA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] ARM64: add cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Naresh Bhat <naresh.bhat@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2013 11:54, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Jul 29, 2013 at 10:46:06AM +0100, Vincent Guittot wrote:
>> On 27 July 2013 12:42, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>> > Power aware scheduling needs the cpu topology information to improve the
>> > cpu scheduler decision making.
>>
>> It's not only power aware scheduling. The scheduler already uses
>> topology and cache sharing when  CONFIG_SCHED_MC and/or
>> CONFIG_SCHED_SMT are enable. So you should also add these configs for
>> arm64 so the scheduler can use it
>
> ... except that the architecture doesn't define what the AFF fields in MPIDR
> really represent. Using them to make key scheduling decisions relating to

Do you mean that it's not define for arm64 ARM? AFAIK, there are good
explanation in the arm32 ARM and it's currently used with SCHED_MC and
SCHED_SMT

> cache proximity seems pretty risky to me, especially given the track record
> we've seen already on AArch32 silicon. It's a convenient register if it
> contains the data we want it to contain, but we need to force ourselves to
> come to terms with reality here and simply use it as an identifier for a
> CPU.
>
> Can't we just use the device-tree to represent this topological data for
> arm64? Lorenzo has been working on bindings in this area.

I agree that we should probably use DT if we can't rely in MPIDR for arm64

Vincent
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
