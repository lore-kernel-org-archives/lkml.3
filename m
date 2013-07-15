Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3GOCGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 22:06:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:54270 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3GOCGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 22:06:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,666,1367996400"; 
   d="scan'208";a="370238949"
Message-ID: <51E358DB.4020705@intel.com>
Date: Mon, 15 Jul 2013 10:05:15 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E17CDD.30805@linux.intel.com>
In-Reply-To: <51E17CDD.30805@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 12:14 AM, Arjan van de Ven wrote:
> 
> 
> on thinking more about the short running task thing; there is an
> optimization we currently don't do,
> mostly for hyperthreading. (and HT is just one out of a set of cases
> with similar power behavior)
> If we know a task runs briefly AND is not performance critical, it's
> much much better to place it on
> a hyperthreading buddy of an already busy core than it is to place it on
> an empty core (or to delay it).
> Yes a HT pair isn't the same performance as a full core, but in terms of
> power the 2nd half of a HT pair
> is nearly free... so if there's a task that's not performance sensitive
> (and won't disturb the other task too much,
> e.g. runs briefly enough)... it's better to pack onto a core than to
> spread.
> you can generalize this to a class of systems where adding work to a
> core (read: group of cpus that share resources)
> is significantly cheaper than running on a full empty core.

Right!
That is one of purpose that my old power sheduling's wanna do:
https://lkml.org/lkml/2013/4/3/747
Vincent's patchset also target at this.

-- 
Thanks
    Alex
