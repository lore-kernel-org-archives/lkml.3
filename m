Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3KLSJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:09:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38433 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3KLSJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:09:13 -0500
Date: Tue, 12 Nov 2013 19:08:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for
 sched_domain init
Message-ID: <20131112180844.GF21461@twins.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <1382097147-30088-2-git-send-email-vincent.guittot@linaro.org>
 <20131105140626.GP31370@twins.programming.kicks-ass.net>
 <CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com>
 <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <20131106145344.448d7733@mschwide>
 <20131106140807.GM10651@twins.programming.kicks-ass.net>
 <528268C8.8010501@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528268C8.8010501@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 05:43:36PM +0000, Dietmar Eggemann wrote:
> This patch removes the sched_domain initializer macros
> SD_[SIBLING|MC|BOOK|CPU]_INIT in core.c and in archs and replaces them
> with calls to the new function sd_init().  The function sd_init
> incorporates the already existing function sd_numa_init().

Your patch retains far too much of the weird behavioural variations we
have, nor does it create a proper separation between topology and
behaviour.

We might indeed have to have a single arch_() function that adds
SD_flags, but please restrict the flags it can set -- never allow it to
set behavioural flags.

Furthermore, I think we want to allow the arch to override the base
topology; we've had desire to add per arch level in the past.. eg. add
an L2 level for some x86 variants.


