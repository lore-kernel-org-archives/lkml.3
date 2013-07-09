Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3GIQ65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:58:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:52149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab3GIQ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:58:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1029,1363158000"; 
   d="scan'208";a="367250582"
Message-ID: <51DC414F.5050900@linux.intel.com>
Date: Tue, 09 Jul 2013 09:58:55 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> Hi,
>
> This patch set is an initial prototype aiming at the overall power-aware
> scheduler design proposal that I previously described
> <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
>
> The patch set introduces a cpu capacity managing 'power scheduler' which lives
> by the side of the existing (process) scheduler. Its role is to monitor the
> system load and decide which cpus that should be available to the process
> scheduler. Long term the power scheduler is intended to replace the currently
> distributed uncoordinated power management policies and will interface a
> unified platform specific power driver obtain power topology information and
> handle idle and P-states. The power driver interface should be made flexible
> enough to support multiple platforms including Intel and ARM.
>
I quickly browsed through it but have a hard time seeing what the
real interface is between the scheduler and the hardware driver.
What information does the scheduler give the hardware driver exactly?
e.g. what does it mean?

If the interface is "go faster please" or "we need you to be at fastest now",
that doesn't sound too bad.
But if the interface is "you should be at THIS number" that is pretty bad and
not going to work for us.

also, it almost looks like there is a fundamental assumption in the code
that you can get the current effective P state to make scheduler decisions on;
on Intel at least that is basically impossible... and getting more so with every generation
(likewise for AMD afaics)

(you can get what you ran at on average over some time in the past, but not
what you're at now or going forward)

I'm rather nervous about calculating how many cores you want active as a core scheduler feature.
I understand that for your big.LITTLE architecture you need this due to the asymmetry,
but as a general rule for more symmetric systems it's known to be suboptimal by quite a
real percentage. For a normal Intel single CPU system it's sort of the worst case you can do
in that it leads to serializing tasks that could have run in parallel over multiple cores/threads.
So at minimum this kind of logic must be enabled/disabled based on architecture decisions.





