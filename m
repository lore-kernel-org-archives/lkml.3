Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3C0IyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:54:15 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39696
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159Ab3C0Iqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:46:34 -0400
Message-ID: <1364373980.5053.57.camel@laptop>
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Date: Wed, 27 Mar 2013 09:46:20 +0100
In-Reply-To: <5151BEF2.9090100@linux.intel.com>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	  <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
	 <1364301998.5053.17.camel@laptop> <5151BEF2.9090100@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 08:29 -0700, Arjan van de Ven wrote:
> > Isn't this basically related to picking the NO_HZ cpu; if the system
> > isn't fully symmetric with its power gates you want the NO_HZ cpu to be
> > the 'special' cpu. If it is symmetric we really don't care which core
> > is left 'running' and we can even select a new pack cpu from the idle
> > cores once the old one is fully utilized.
> 
> you don't really care much sure, but there's some advantages for sorting "all the way left",
> e.g. to linux cpu 0.
> Some tasks only run there, and interrupts tend to be favored to that cpu as well on x86.

Right, and I suspect all the big-little nonsense will have the little
cores on low numbers as well (is this architected or can a creative
licensee screw us over?)

So find_new_ilb() already does cpumask_first(), so it has a strong
leftmost preference. We just need to make sure it indeed does the right
thing and doesn't have some unintended side effect.

