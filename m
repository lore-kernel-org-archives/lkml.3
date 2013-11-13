Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3KMR4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:56:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:19454 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab3KMR4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:56:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,693,1378882800"; 
   d="scan'208";a="427050211"
Message-ID: <5283BD4C.3040600@linux.intel.com>
Date: Wed, 13 Nov 2013 09:56:28 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "l.majewski@samsung.com" <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org> <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com> <20131111163630.GD26898@twins.programming.kicks-ass.net> <52810851.4090907@linux.intel.com> <20131111181805.GE29572@arm.com> <52825BE9.2080605@linux.intel.com> <42638CC1-ACC7-4330-A4F4-D78C88BE8155@arm.com> <5283A545.4040406@linux.intel.com> <20131113164457.GF18837@arm.com>
In-Reply-To: <20131113164457.GF18837@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> for picking the cpu to wake on there are also low level physical kind of things
>> we'd want to take into account on the intel side.
>
> Are these static and could they be hidden behind some cost number in a
> topology description? If they are dynamic, we would need arch or driver
> hooks to give some cost or priority number that the scheduler can use.

they're dynamic but slow moving (say, reevaluated once per second)

so we could have a static table that some driver updates async

