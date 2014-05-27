Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaE0HbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:31:01 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36735 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaE0Ha6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:30:58 -0400
MIME-Version: 1.0
In-Reply-To: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 27 May 2014 09:30:37 +0200
Message-ID: <CAKfTPtAb45b0KC==k7+DB_JZrXsSHcLFrn=oenX3wnS42eK6Xg@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] sched: expel confusing usage of the term "power"
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

There are still some use of "power" instead of "capacity" in the sched
directory like SD_SHARE_CPUPOWER, ARCH_POWER or NONTASK_POWER. They
should also be renamed in capacity as there are also used for capacity

Vincent

On 27 May 2014 00:19, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> "Power" is a very bad term in the scheduler context.  There are so many
> meanings that can be attached to it.  And with the upcoming "power
> aware" scheduler work, confusion is sure to happen.
>
> The definition of "power" is typically the rate at which work is performed,
> energy is converted or electric energy is transferred.  The notion of
> "compute capacity" is rather at odds with "power" to the point many
> comments in the code have to make it explicit that "capacity" is the
> actual intended meaning.
>
> So let's make it clear what we man by using "capacity" in place of "power"
> directly in the code.  That will make the introduction of actual "power
> consumption" concepts much clearer later on.
>
> This is based on the latest tip tree to apply correctly on top of existing
> scheduler changes already queued there.
>
> Changes from v1:
>
> - capa_factor and SCHED_CAPA_* changed to be spelled "capacity" in full
>   to save peterz some Chupacabra nightmares
>
> - some minor corrections in commit logs
>
> - rebased on latest tip tree
>
>
>  arch/arm/kernel/topology.c |  54 +++----
>  include/linux/sched.h      |   8 +-
>  kernel/sched/core.c        |  87 ++++++-----
>  kernel/sched/fair.c        | 323 ++++++++++++++++++++-------------------
>  kernel/sched/sched.h       |  18 +--
>  5 files changed, 246 insertions(+), 244 deletions(-)
