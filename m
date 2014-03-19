Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbaCSMB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:01:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58910 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSMB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:01:56 -0400
Date: Wed, 19 Mar 2014 13:01:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        preeti@linux.vnet.ibm.com, tony.luck@intel.com, fenghua.yu@intel.com,
        schwidefsky@de.ibm.com, james.hogan@imgtec.com, cmetcalf@tilera.com,
        benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 5/7] sched: add a new SD_SHARE_POWERDOMAIN for
 sched_domain
Message-ID: <20140319120122.GK27632@laptop.programming.kicks-ass.net>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
 <1395165409-18055-6-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395165409-18055-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 06:56:47PM +0100, Vincent Guittot wrote:
> A new flag SD_SHARE_POWERDOMAIN is created to reflect whether groups of CPUs
> in a sched_domain level can or not reach different power state. As an example,
> the flag should be cleared at CPU level if groups of cores can be power gated
> independently. This information can be used to add load balancing level between
> group of CPUs than can power gate independantly. The default behavior of the
> scheduler is to spread tasks across CPUs and groups of CPUs 

> so the flag is set into all sched_domains.

I suppose that is the part Preeti stumbled over; as did I. Its not set
at all.
