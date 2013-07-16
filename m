Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab3GPPXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:23:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:60057 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932864Ab3GPPXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:23:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,677,1367996400"; 
   d="scan'208";a="332180235"
Message-ID: <51E5655C.7050304@linux.intel.com>
Date: Tue, 16 Jul 2013 08:23:08 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <20130713102350.GA8067@MacBook-Pro.local> <20130715203922.GD23818@dyad.programming.kicks-ass.net> <20130716124248.GB10036@arm.com>
In-Reply-To: <20130716124248.GB10036@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/2013 5:42 AM, Catalin Marinas wrote:
> Morten's power scheduler tries to address the above and it will grow
> into controlling a new model of power driver (and taking into account
> Arjan's and others' comments regarding the API). At the same time, we
> need some form of task packing. The power scheduler can drive this
> (currently via cpu_power) or can simply turn a knob if there are better
> options that will be accepted in the scheduler.

how much would you be helped if there was a simple switch

sort left   versus    sort right

(assuming the big cores are all either low or high numbers)

the sorting is mostly statistical, but that's good enough in practice..
each time a task wakes up, you get a bias towards either low or high
numbered idle cpus

very quickly all tasks will be on one side, unless your system is so
loaded that all cpus are full.

