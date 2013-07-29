Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3G2NNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:13:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:4421 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab3G2NNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,769,1367996400"; 
   d="scan'208";a="353570516"
Message-ID: <51F66A5A.9060901@linux.intel.com>
Date: Mon, 29 Jul 2013 06:12:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Rik van Riel <riel@redhat.com>, Jeremy Eder <jeder@redhat.com>,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        youquan.song@intel.com, paulmck@linux.vnet.ibm.com,
        len.brown@intel.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <51F2BC31.7000407@redhat.com> <51F2BF8C.7010308@linux.intel.com> <51F2C014.90102@redhat.com> <51F37290.5050101@linaro.org>
In-Reply-To: <51F37290.5050101@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> The menu governor tries to deduce the next wakeup but based on events
> per cpu. That means if a task with a specific behavior is migrated
> across cpus, the statistics will be wrong.


btw this is largely a misunderstanding;
tasks are not the issue; tasks use timers and those are perfectly predictable.
It's interrupts that are not and the heuristics are for that.

Now, if your hardware does the really-bad-for-power wake-all on any interrupt,
then the menu governor logic is not good for you; rather than looking at the next
timer on the current cpu you need to look at the earliest timer on the set of bundled
cpus as the upper bound of the next wake event.
And maybe even more special casing is needed... but I doubt it.


