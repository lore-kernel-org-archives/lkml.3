Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3GBFiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:38:46 -0400
Received: from mout.gmx.net ([212.227.15.15]:57624 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab3GBFip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:38:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18KAIA63vQKAGMi2tFSKVYnT+7aHPLFWCTPlxb9He
	VHp3pdVH8RVJQJ
Message-ID: <1372743517.7363.129.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Tue, 02 Jul 2013 07:38:37 +0200
In-Reply-To: <51D25A80.8090406@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51D25A80.8090406@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 12:43 +0800, Michael Wang wrote:

> +static int nasty_pull(struct task_struct *p)
> +{
> +	int factor = cpumask_weight(cpu_online_mask);
> +
> +	/*
> +	 * Yeah, it's the switching-frequency, could means many wakee or
> +	 * rapidly switch, use factor here will just help to automatically
> +	 * adjust the loose-degree, so more cpu will lead to more pull.
> +	 */
> +	if (p->nr_wakee_switch > factor) {
> +		/*
> +		 * wakee is somewhat hot, it needs certain amount of cpu
> +		 * resource, so if waker is far more hot, prefer to leave
> +		 * it alone.
> +		 */
> +		if (current->nr_wakee_switch > (factor * p->nr_wakee_switch))
> +			return 1;
> +	}
> +
> +	return 0;
> +}

Ew.  I haven't gotten around to test-driving this patchlet, and I see
you haven't gotten around to finding a better name either.  Any other
name will likely have a better chance of flying.

tasks_related()
...
well, nearly any..
tasks_think_wake_affine_sucks_rocks()
..that won't fly either :)

-Mike

