Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaEOHld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:41:33 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:34470 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaEOHlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:41:32 -0400
MIME-Version: 1.0
In-Reply-To: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 15 May 2014 09:41:11 +0200
Message-ID: <CAKfTPtAtiiWN9t_VswTienkBBCiUpqnZdvsnOVnTphc0PF69Rg@mail.gmail.com>
Subject: Re: [PATCH 0/6] sched: expel confusing usage of the term "power"
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

Hi Nico,

Thanks for doing this renaming.
I remember that you asked me to do this while working on cpu_power but
my work has not evolved as fast as expected and as it already implies
some renaming other than s/power/capacity/ i have postponed it to not
make review to complex.

Nevertheless, i can manage the conflicts afterward and rebase my
patches, depending of the review status

Vincent

On 14 May 2014 22:57, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> "Power" is a very bad term in the scheduler context.  There are so many
> meanings that can be attached to it.  And with the upcoming "power
> aware" scheduler work confusion is sure to happen.
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
> This is based on the latest tip tree where scheduler changes are already
> queued.
>
> Note: The diffstat is not completely symetric wrt added/removed lines as
> some comments were reflowed.
>
>
>  arch/arm/kernel/topology.c |  54 +++----
>  include/linux/sched.h      |   8 +-
>  kernel/sched/core.c        |  89 ++++++-----
>  kernel/sched/fair.c        | 322 ++++++++++++++++++++-------------------
>  kernel/sched/sched.h       |  18 +--
>  5 files changed, 246 insertions(+), 245 deletions(-)
>
>
> Nicolas
