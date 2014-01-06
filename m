Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaAFQ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:28:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaAFQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:28:46 -0500
Date: Mon, 6 Jan 2014 17:28:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
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
Message-ID: <20140106162813.GM31570@twins.programming.kicks-ass.net>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52B87149.4010801@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B87149.4010801@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 06:22:17PM +0100, Dietmar Eggemann wrote:
> I'm not sure if the idea to create a dedicated sched_domain level for every
> topology flag representing a specific functionality will scale. From the
> perspective of energy-aware scheduling we need e.g. energy costs (P and C
> state) which can only be populated towards the scheduler via an additional
> sub-struct and additional function arch_sd_energy() like depicted in
> Morten's email:
> 
> [2] lkml.org/lkml/2013/11/14/102

That lkml.org link is actually not working for me (blank page -- maybe
lkml.org is on the blink again).

That said, I yet have to sit down and think about the P state stuff, but
I was thinking we need some rudimentary domain support for that.

For instance, the big-little thingies seem share their P state per
cluster, so we need a domain at that level to hang some state off of --
which we actually have in this case. But we need to ensure we do have
it -- somehow.

