Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaAFQeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:34:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35436 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaAFQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:34:07 -0500
Date: Mon, 6 Jan 2014 17:33:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, Morten.Rasmussen@arm.com,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@linaro.org,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        james.hogan@imgtec.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, Dietmar.Eggemann@arm.com
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140106163341.GO31570@twins.programming.kicks-ass.net>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52C3A0F1.3040803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C3A0F1.3040803@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 10:30:33AM +0530, Preeti U Murthy wrote:
> The design looks good to me. In my opinion information like P-states and
> C-states dependency can be kept separate from the topology levels, it
> might get too complicated unless the information is tightly coupled to
> the topology.

I'm not entirely convinced we can keep them separated, the moment we
have multiple CPUs sharing a P or C state we need somewhere to manage
the shared state and the domain tree seems like the most natural place
for this.

Now it might well be both P and C states operate at 'natural' domains
which we already have so it might be 'easy'.
