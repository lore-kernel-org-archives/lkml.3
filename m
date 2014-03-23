Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaCWDNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 23:13:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:42784 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaCWDNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 23:13:50 -0400
Message-ID: <1395544326.3460.98.camel@pasglop>
Subject: Re: [PATCH v3 6/6] sched: powerpc: Add SD_SHARE_POWERDOMAIN for SMT
 level
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
        fenghua.yu@intel.com, schwidefsky@de.ibm.com, james.hogan@imgtec.com,
        cmetcalf@tilera.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, dietmar.eggemann@arm.com,
        linaro-kernel@lists.linaro.org
Date: Sun, 23 Mar 2014 14:12:06 +1100
In-Reply-To: <532E3DB4.9060908@linux.vnet.ibm.com>
References: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org>
	 <1395246165-31150-7-git-send-email-vincent.guittot@linaro.org>
	 <532E3DB4.9060908@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-23 at 07:19 +0530, Preeti U Murthy wrote:
> We were discussing the impact of this consolidation and we are not too
> sure if it will yield us good power efficiency. So we would want to
> experiment with the power aware scheduler to find the "sweet spot" for
> the number of threads to consolidate to and more importantly if there
> is
> one such number at all. Else we would not want to go this way at all.
> Hence it looks best if this patch is dropped until we validate it. We
> don't want the code getting in and then out if we find out later there
> are no benefits to it.
> 
> I am sorry that I suggested this patch a bit pre-mature in the
> experimentation and validation stage. When you release the load
> balancing patchset for power aware scheduler I shall validate this
> patch. But until then its best if it does not get merged.

It's quite possible that we never find a correct "sweet spot" for all
workloads.

Ideally, the "target" number of used threads per core should be a
tunable so that the user / distro can "tune" based on a given workload
whether to pack cores and how much to pack them, vs. spreading the
workload. Akin to scheduling for performance vs. power in a way (though
lower perf usually means higher power due to longer running jobs of
course).

In any case, we need to experiment.

Cheers,
Ben.
 

