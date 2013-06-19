Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3FSPkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:40:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:18673 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab3FSPkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:40:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,898,1363158000"; 
   d="scan'208";a="352406318"
Message-ID: <51C1D0BB.3040705@linux.intel.com>
Date: Wed, 19 Jun 2013 08:39:39 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, catalin.marinas@arm.com
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin> <51C07ABC.2080704@linux.intel.com> <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/2013 10:47 AM, David Lang wrote:

>
> It's bad enough trying to guess the needs of the processes, but if you also are reduced to guessing the capabilities of the cores, how can anything be made to work?

btw one way to look at this is to assume that (with some minimal hinting)
the CPU driver will do the right thing and get you just about the best performance you can get
(that is appropriate for the task at hand)...
... and don't do anything in the scheduler proactively.

Now for big.little and other temporary or permanent asymmetries, we may want to
have a "max performance level" type indicator, and that's fair enough
(and this can be dynamic, since it for thermal reasons this can change over time,
but on a somewhat slower timescale)


the hints I have in mind are not all that complex; we have the biggest issues today
around task migration (the task migrates to a cold cpu... so a simple notifier chain
on the new cpu as it is accepting a task and we can bump it up), real time tasks
(again, simple notifier chain to get you to a predictably high performance level)
and we're a long way better than we are today in terms of actual problems.

For all the talk of ondemand (as ARM still uses that today)... that guy puts you in
either the lowest or highest frequency over 95% of the time. Other non-cpufreq solutions
like on Intel are bit more advanced (and will grow more so over time), but even there,
in the grand scheme of things, the scheduler shouldn't have to care anymore with those
two notifiers in place.


