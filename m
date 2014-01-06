Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbaAFQhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:37:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:19444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbaAFQhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:37:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,613,1384329600"; 
   d="scan'208";a="332352276"
Message-ID: <52CADBB9.1010704@linux.intel.com>
Date: Mon, 06 Jan 2014 08:37:13 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, Morten.Rasmussen@arm.com,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@linaro.org,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, amit.kucheria@linaro.org, james.hogan@imgtec.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        Dietmar.Eggemann@arm.com
Subject: Re: [RFC] sched: CPU topology try
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net> <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org> <52C3A0F1.3040803@linux.vnet.ibm.com> <20140106163341.GO31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140106163341.GO31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2014 8:33 AM, Peter Zijlstra wrote:
> On Wed, Jan 01, 2014 at 10:30:33AM +0530, Preeti U Murthy wrote:
>> The design looks good to me. In my opinion information like P-states and
>> C-states dependency can be kept separate from the topology levels, it
>> might get too complicated unless the information is tightly coupled to
>> the topology.
>
> I'm not entirely convinced we can keep them separated, the moment we
> have multiple CPUs sharing a P or C state we need somewhere to manage
> the shared state and the domain tree seems like the most natural place
> for this.
>
> Now it might well be both P and C states operate at 'natural' domains
> which we already have so it might be 'easy'.

more than that though.. P and C state sharing is mostly hidden from the OS
(because the OS does not have the ability to do this; e.g. there are things
that do "if THIS cpu goes idle, the OTHER cpu P state changes automatic".

that's not just on x86, the ARM guys (iirc at least the latest snapdragon)  are going in that
direction as well.....

for those systems, the OS really should just make local decisions and let the hardware
cope with hardware grouping.
>

