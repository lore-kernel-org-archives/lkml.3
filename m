Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab3GLMvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:51:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40286 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab3GLMvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:51:02 -0400
Date: Fri, 12 Jul 2013 13:51:13 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 8/9] sched: power: Add initial frequency scaling
 support to power scheduler
Message-ID: <20130712125113.GF20960@e103034-lin>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <1373385338-12983-9-git-send-email-morten.rasmussen@arm.com>
 <51DD5D63.7000602@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51DD5D63.7000602@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Jul 2013 12:50:58.0585 (UTC) FILETIME=[74BFE890:01CE7EFE]
X-MC-Unique: 113071213505901301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 02:10:59PM +0100, Arjan van de Ven wrote:
> On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> > Extends the power scheduler capacity management algorithm to handle
> > frequency scaling and provide basic frequency/P-state selection hints
> > to the power driver.
> >
> > Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> > CC: Ingo Molnar <mingo@kernel.org>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >   kernel/sched/power.c |   33 ++++++++++++++++++++++++++++-----
> >   1 file changed, 28 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/sched/power.c b/kernel/sched/power.c
> > index 9e44c0e..5fc32b0 100644
> > --- a/kernel/sched/power.c
> > +++ b/kernel/sched/power.c
> > @@ -21,6 +21,8 @@
> >
> >   #define INTERVAL 5 /* ms */
> >   #define CPU_FULL 90 /* Busy %-age - TODO: Make tunable */
> > +#define CPU_TARGET 80 /* Target busy %-age - TODO: Make tunable */
> > +#define CPU_EMPTY 5 /* Idle noise %-age - TODO: Make tunable */
> >
> 
> to be honest, this is the policy part that really should be in the hardware specific driver
> and not in the scheduler.
> (even if said driver is sort of a "generic library" kind of thing)

I agree that the values should be set by a hardware specific power
driver. Or do you mean that algorithms using this sort of values should
be in the driver?

