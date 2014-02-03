Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaBCOiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:38:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:42491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbaBCOiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:38:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,772,1384329600"; 
   d="scan'208";a="469052641"
Message-ID: <52EFA9D3.1030601@linux.intel.com>
Date: Mon, 03 Feb 2014 06:38:11 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net> <52EA8B07.6020206@linaro.org> <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com> <52EBC33A.6080101@linaro.org> <52EBC645.2040607@linux.intel.com> <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr> <20140203125441.GD19029@e103034-lin>
In-Reply-To: <20140203125441.GD19029@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/2014 4:54 AM, Morten Rasmussen wrote:

>
> I'm therefore not convinced that idle state index is the right thing to
> give the scheduler. Using a cost metric would be better in my
> opinion.


I totally agree with this, and we may need two separate cost metrics

1) A latency driven one
2) A performance impact on

first one is pretty much the exit latency related time, sort of a "expected time to first instruction"
(currently menuidle has the 99.999% worst case number, which is not useful for this, but is a first
approximation). This is obviously the dominating number for expected-short running tasks

second on is more of a "is there any cache/TLB left or is it flushed" kind of metric. It's more tricky
to compute, since what is the cost of an empty cache (or even a cache migration) after all....
.... but I suspect it's in part what the scheduler will care about more for expected-long  running tasks.




