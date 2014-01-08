Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaAHMqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:46:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56725 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaAHMp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:45:59 -0500
Date: Wed, 8 Jan 2014 13:45:34 +0100
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
Message-ID: <20140108124534.GD31570@twins.programming.kicks-ass.net>
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
> > Currently we detect overload by sg.nr_running >= sg.capacity, which can
> > be very misleading because while a cpu might have a task running 'now'
> > it might be 99% idle.
> > 
> > At which point I argued we should change the capacity thing anyhow. Ever
> > since the runnable_avg patch set I've been arguing to change that into
> > an actual utilization test.
> > 
> > So I think that if we measure overload by something like >95% utilization
> > on the entire group the load scaling again makes perfect sense.
> 
> I agree that it make more sense to change the overload test to be based
> on some tracked load. How about the non-overloaded case? Load balancing
> would have to be based on unweighted task loads in that case?

Yeah, until we're overloaded our goal is to minimize idle time.
