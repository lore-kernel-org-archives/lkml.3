Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab3HOBCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 21:02:19 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53511 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3HOBCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 21:02:18 -0400
Message-ID: <520C2835.6050001@linaro.org>
Date: Thu, 15 Aug 2013 09:00:37 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
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
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: [RFC][PATCH 1/2] ARM64: add cpu topology definition
References: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org> <CAKfTPtBpo41LJ3V8TB8YwudwqpURuA2u_Lvu4KYVK=qSs+gFuQ@mail.gmail.com> <20130729095400.GB32383@mudshark.cambridge.arm.com> <20130814112720.GB43445@MacBook-Pro.local>
In-Reply-To: <20130814112720.GB43445@MacBook-Pro.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-8-14 19:27, Catalin Marinas wrote:
> On Mon, Jul 29, 2013 at 10:54:01AM +0100, Will Deacon wrote:
>> On Mon, Jul 29, 2013 at 10:46:06AM +0100, Vincent Guittot wrote:
>>> On 27 July 2013 12:42, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>>> Power aware scheduling needs the cpu topology information to improve the
>>>> cpu scheduler decision making.
>>>
>>> It's not only power aware scheduling. The scheduler already uses
>>> topology and cache sharing when  CONFIG_SCHED_MC and/or
>>> CONFIG_SCHED_SMT are enable. So you should also add these configs for
>>> arm64 so the scheduler can use it
>>
>> ... except that the architecture doesn't define what the AFF fields in MPIDR
>> really represent. Using them to make key scheduling decisions relating to
>> cache proximity seems pretty risky to me, especially given the track record
>> we've seen already on AArch32 silicon. It's a convenient register if it
>> contains the data we want it to contain, but we need to force ourselves to
>> come to terms with reality here and simply use it as an identifier for a
>> CPU.
>>
>> Can't we just use the device-tree to represent this topological data for
>> arm64? Lorenzo has been working on bindings in this area.
> 
> Catching up on email after holiday - I agree with Will here, we should
> use DT for representing the topology (or ACPI) and not rely on the MPIDR
> value.
> 

Ok, I'm working on the ACPI part now, Thanks for your comments.

Regards
Hanjun
