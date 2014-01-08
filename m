Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbaAHMn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:43:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56678 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbaAHMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:43:26 -0500
Date: Wed, 8 Jan 2014 13:42:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140108124253.GC31570@twins.programming.kicks-ass.net>
References: <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52B87149.4010801@arm.com>
 <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
 <20140106163123.GN31570@twins.programming.kicks-ass.net>
 <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
 <20140107132220.GZ31570@twins.programming.kicks-ass.net>
 <20140107141059.GY3694@twins.programming.kicks-ass.net>
 <20140107154154.GH2936@e103034-lin>
 <20140107204951.GD2480@laptop.programming.kicks-ass.net>
 <20140108123534.GI2936@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108123534.GI2936@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 12:35:34PM +0000, Morten Rasmussen wrote:
> > The harder case is where all 3 tasks are of equal weight; in which case
> > fairness would mandate we (slowly) rotate the tasks such that they all
> > get 2/3 time -- we also horribly fail at this :-)
> 
> I have encountered that one a number of times. All the middleware noise
> in Android sometimes give that effect.

You've got a typo there: s/middleware/muddleware/ :-)

> I'm not sure if the NUMA guy would like rotating scheduler though :-)

Hurmph ;-) But yes, the N+1 tasks on a N cpu system is rotten; any
static solution gets 2 tasks that run at 50%, any dynamic solution gets
the migration overhead issue.

So while the dynamic solution would indeed allow each task to (on
average) receive N/N+1 time -- a vast improvement over the 50% thing, it
doesn't come without down sides.
