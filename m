Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaE0QCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:02:10 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34889 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaE0QCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:02:08 -0400
Date: Tue, 27 May 2014 12:02:06 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 0/6] sched: expel confusing usage of the term
 "power"
In-Reply-To: <53849C13.5010007@linaro.org>
Message-ID: <alpine.LFD.2.11.1405271140050.17310@knanqh.ubzr>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org> <53849C13.5010007@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Daniel Lezcano wrote:

> On 05/27/2014 12:19 AM, Nicolas Pitre wrote:
> > "Power" is a very bad term in the scheduler context.  There are so many
> > meanings that can be attached to it.  And with the upcoming "power
> > aware" scheduler work, confusion is sure to happen.
> >
> > The definition of "power" is typically the rate at which work is performed,
> > energy is converted or electric energy is transferred.  The notion of
> > "compute capacity" is rather at odds with "power" to the point many
> > comments in the code have to make it explicit that "capacity" is the
> > actual intended meaning.
> >
> > So let's make it clear what we man by using "capacity" in place of "power"
> > directly in the code.  That will make the introduction of actual "power
> > consumption" concepts much clearer later on.
> >
> > This is based on the latest tip tree to apply correctly on top of existing
> > scheduler changes already queued there.
> >
> > Changes from v1:
> >
> > - capa_factor and SCHED_CAPA_* changed to be spelled "capacity" in full
> >    to save peterz some Chupacabra nightmares
> >
> > - some minor corrections in commit logs
> >
> > - rebased on latest tip tree
> >
> >
> >   arch/arm/kernel/topology.c |  54 +++----
> >   include/linux/sched.h      |   8 +-
> >   kernel/sched/core.c        |  87 ++++++-----
> >   kernel/sched/fair.c        | 323 ++++++++++++++++++++-------------------
> >   kernel/sched/sched.h       |  18 +--
> >   5 files changed, 246 insertions(+), 244 deletions(-)
> 
> Hi Nico,
> 
> it is a good initiative to replace the 'power' word by another to prevent
> confusion for future code. Personally I have a preference to 'strength'
> instead of 'capacity', in case that matter.

Proper usage does matter:

Strength could mean many things.  Among them:

Physical ability

     * Physical strength, as in people or animals

As an abstract or psychological trait

     * Virtue and moral uprightness
     * Courage or fortitude in the face of moral or social pressure
     * Persuasiveness of an argument
     * The exercise of willpower

Physics

     * Strength of materials, ability to withstand an applied stress 
       without failure
          + Compressive strength, capacity to withstand axially directed 
            pushing forces
          + Tensile strength, maximum stress while being stretched or 
            pulled before necking
          + Shear strength, the ability to withstand shearing
     * Strength (explosive), the ability of an explosive to move 
       surrounding material
     * Field strength, the magnitude of a field's vector
     * Signal strength, the magnitude of an electric field at a 
       reference point

I have difficulty referring to "CPU strength" without still be confused 
about what exactly this would mean.  None of the above definitions would 
provide a sufficiently close analogy to be applied without ambiguity.

On the other hand, the definition for capacity is much narrower:

1.
a. The ability to receive, hold, or absorb.
b. Abbr. c. A measure of this ability; volume.

2. The maximum amount that can be contained: a trunk filled to capacity.

3.
a. Ability to perform or produce; capability.
b. The maximum or optimum amount that can be produced: factories 
operating below capacity.

Etc.

Here the analogy with "CPU capacity" or "compute capacity" is clear and 
natural for what we are applying this term to.


Nicolas
