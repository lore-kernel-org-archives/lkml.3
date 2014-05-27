Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaE0OHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:07:06 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:51381 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaE0OHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:07:03 -0400
Message-ID: <53849C13.5010007@linaro.org>
Date: Tue, 27 May 2014 16:07:15 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 0/6] sched: expel confusing usage of the term "power"
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
In-Reply-To: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 12:19 AM, Nicolas Pitre wrote:
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
>    to save peterz some Chupacabra nightmares
>
> - some minor corrections in commit logs
>
> - rebased on latest tip tree
>
>
>   arch/arm/kernel/topology.c |  54 +++----
>   include/linux/sched.h      |   8 +-
>   kernel/sched/core.c        |  87 ++++++-----
>   kernel/sched/fair.c        | 323 ++++++++++++++++++++-------------------
>   kernel/sched/sched.h       |  18 +--
>   5 files changed, 246 insertions(+), 244 deletions(-)

Hi Nico,

it is a good initiative to replace the 'power' word by another to 
prevent confusion for future code. Personally I have a preference to 
'strength' instead of 'capacity', in case that matter.

Apart that:

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

