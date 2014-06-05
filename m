Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaFFGu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:50:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:62294 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaFFGu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:50:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,987,1392192000"; 
   d="scan'208";a="523696452"
Date: Fri, 6 Jun 2014 06:46:29 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, rafael.j.wysocki@intel.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        alan.cox@intel.com, "Gross, Mark" <mark.gross@intel.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        jacob.jun.pan@linux.intel.com,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH] sched: remove rq's runnable load average
Message-ID: <20140605224628.GA22261@intel.com>
References: <1401922297-9729-1-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAg6uvhR4hLpifmev4oCPPtuQ1xDWTuxDe2OzG6Ldvk7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAg6uvhR4hLpifmev4oCPPtuQ1xDWTuxDe2OzG6Ldvk7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 10:32:31AM +0200, Vincent Guittot wrote:
> Hi Yuyang,
> 
> I have started to use it in this patchset https://lkml.org/lkml/2014/5/23/458
> 
Hi Vincent and PeterZ,

I saw your patchset: https://lkml.org/lkml/2014/5/23/458. But don't take it
wrong, I did not intentionally attempt to remove rq->avg to prevent you from
using it. If your patchset gets merged, sure we should keep it. Otherwise, we
need to see whether there is other objection to remove it, because it has been
almost two years that is not used, I don't see any goodness of it in the
critical path but never used.

In addition, I want to market CPU ConCurrency (CC) as a candidate for CPU
unweighted load metric. Hope you can use it. And also try to answer
PeterZ's question: why not utilization, but CC?

CPU utilization, specifically CPU busy ratio, misses the tasks wanting/using
the CPU. I already explained it several times. So this time I'd like to make
some examples. Take 50% utilization for example, we really can't say 50% is
high or low for scheduler, because if it is just 1 task using it, it is low,
but if 100 tasks sharing it, it is already very high. And take 100%
utilization for example, if it is just 1 task, we can't say it is high in the
sense that give it another CPU does not help. So maybe you want to also
reference nr_running, but nr_running is too dynamic to use as it is.

On the contrary, CC understands not only CPU utilization but also tasks
utilizing the CPU. The averaged metric can 1) tolerate transient tasks as it
evens nr_running, and 2) know when CPU is utilized, because CC should be no
less than CPU utilization in general, 3) we just need to compare it with 1 as
the threshold, so not struggle in selecting what threshold to distinguish high
or low workload in the CPU utilization case. Right?

Thanks,
Yuyang

