Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3KKQlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:41:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:51449 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab3KKQlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:41:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,679,1378882800"; 
   d="scan'208";a="425651204"
Message-ID: <52810851.4090907@linux.intel.com>
Date: Mon, 11 Nov 2013 08:39:45 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>, l.majewski@samsung.com,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org> <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com> <20131111163630.GD26898@twins.programming.kicks-ass.net>
In-Reply-To: <20131111163630.GD26898@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think the scheduler simply wants to say: we expect to go idle for X
> ns, we want a guaranteed wakeup latency of Y ns -- go do your thing.

as long as Y normally is "large" or "infinity" that is ok ;-)
(a smaller Y will increase power consumption and decrease system performance)



> I think you also raised the point in that we do want some feedback as to
> the cost of waking up particular cores to better make decisions on which
> to wake. That is indeed so.

having a hardware driver give a prefered CPU ordering for wakes can indeed be useful.
(I'm doubtful that changing the recommendation for each idle is going to pay off,
but proof is in the pudding; there are certainly long term effects where this can help)

>

