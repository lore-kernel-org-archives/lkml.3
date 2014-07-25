Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbaGYOb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:31:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:17679 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaGYObz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:31:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,731,1400050800"; 
   d="scan'208";a="575400786"
Message-ID: <53D26A3C.6080707@intel.com>
Date: Fri, 25 Jul 2014 22:31:24 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [LKP] [rcu] c0f489d2c6f: -1.5% netperf.Throughput_tps
References: <53d1f486.t70cWJ/Ilm6Y3o5/%fengguang.wu@intel.com>	 <53D1FD0E.4080406@intel.com> <1406273721.5162.9.camel@marge.simpson.net>	 <53D20FD0.90204@intel.com> <1406281461.5162.38.camel@marge.simpson.net>
In-Reply-To: <1406281461.5162.38.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 05:44 PM, Mike Galbraith wrote:
> On Fri, 2014-07-25 at 16:05 +0800, Aaron Lu wrote: 
>> On 07/25/2014 03:35 PM, Mike Galbraith wrote:
>>> On Fri, 2014-07-25 at 14:45 +0800, Aaron Lu wrote: 
>>>> FYI, we noticed the below changes on
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>>>> commit c0f489d2c6fec8994c642c2ec925eb858727dc7b ("rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs")
>>>>
>>>> abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
>>>> ---------------  -------------------------  
>>>>      12654 ~ 0%      -1.5%      12470 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>>>>      12654 ~ 0%      -1.5%      12470 ~ 0%  TOTAL netperf.Throughput_tps
>>>
>>> Out of curiosity, what parameters do you use for this test?  In my
>>
>> The cmdline for this test is:
>> netperf -t TCP_CRR -c -C -l 300
> 
> Thanks.  That doesn't switch as heftily as plain TCP_RR, but I'd still
> expect memory layout etc to make bisection frustrating as heck.  But no
> matter, I was just curious.

The bisect is done by the LKP test system(developed by Fengguang)
automatically so it's not that painful for me :-) But as you have said,
the 1.5% change is too small and probably doesn't worth a report, I'll
be more careful next time when examining the report.

> 
> Aside: running unbound, the load may get beaten up pretty bad by nohz if
> it's enabled.  Maybe for testing the network stack it'd be better to
> remove that variable?  Dunno, just a thought.  I only mention it because

The CONFIG_NO_HZ_FULL is set to y, I'll disable it to see if the number
changes, thanks for the tips.

Regards,
Aaron

> your numbers look very low unless the box is ancient or CPU is dinky.
> 
> -Mike
> 

