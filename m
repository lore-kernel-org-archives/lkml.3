Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaICPaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:30:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:40729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbaICPaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:30:14 -0400
Date: Wed, 3 Sep 2014 17:30:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [QUERY] Confusing usage of rq->nr_running in load balancing
Message-ID: <20140903153011.GR4783@worktop.ger.corp.intel.com>
References: <540707D9.4040208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540707D9.4040208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 05:51:45PM +0530, Preeti U Murthy wrote:
> Hi,
> 
> There are places in kernel/sched/fair.c in the load balancing part where
> rq->nr_running is used as against cfs_rq->nr_running. At least I could

> Did I miss something or is it true that the usage of rq->nr_running in
> the above places is incorrect?

Yeah, smells fishy. Probably hysterical accidents that haven't been
cleaned up yet. I do remember a few patches cleaning some of this up
recently. Clearly there's more to do.
