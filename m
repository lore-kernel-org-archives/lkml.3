Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3G2JyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:54:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33979 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755019Ab3G2JyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:54:07 -0400
Date: Mon, 29 Jul 2013 10:54:01 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
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
        Tomasz Nowicki <tomasz.nowicki@linaro.org>, lorenzo.pieralisi@arm.com
Subject: Re: [RFC][PATCH 1/2] ARM64: add cpu topology definition
Message-ID: <20130729095400.GB32383@mudshark.cambridge.arm.com>
References: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org>
 <CAKfTPtBpo41LJ3V8TB8YwudwqpURuA2u_Lvu4KYVK=qSs+gFuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBpo41LJ3V8TB8YwudwqpURuA2u_Lvu4KYVK=qSs+gFuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:46:06AM +0100, Vincent Guittot wrote:
> On 27 July 2013 12:42, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > Power aware scheduling needs the cpu topology information to improve the
> > cpu scheduler decision making.
> 
> It's not only power aware scheduling. The scheduler already uses
> topology and cache sharing when  CONFIG_SCHED_MC and/or
> CONFIG_SCHED_SMT are enable. So you should also add these configs for
> arm64 so the scheduler can use it

... except that the architecture doesn't define what the AFF fields in MPIDR
really represent. Using them to make key scheduling decisions relating to
cache proximity seems pretty risky to me, especially given the track record
we've seen already on AArch32 silicon. It's a convenient register if it
contains the data we want it to contain, but we need to force ourselves to
come to terms with reality here and simply use it as an identifier for a
CPU.

Can't we just use the device-tree to represent this topological data for
arm64? Lorenzo has been working on bindings in this area.

Will
