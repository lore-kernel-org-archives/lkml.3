Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbaGYIF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:05:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:8141 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759878AbaGYIFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="567065622"
Message-ID: <53D20FD0.90204@intel.com>
Date: Fri, 25 Jul 2014 16:05:36 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [LKP] [rcu] c0f489d2c6f: -1.5% netperf.Throughput_tps
References: <53d1f486.t70cWJ/Ilm6Y3o5/%fengguang.wu@intel.com>	 <53D1FD0E.4080406@intel.com> <1406273721.5162.9.camel@marge.simpson.net>
In-Reply-To: <1406273721.5162.9.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 03:35 PM, Mike Galbraith wrote:
> On Fri, 2014-07-25 at 14:45 +0800, Aaron Lu wrote: 
>> FYI, we noticed the below changes on
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>> commit c0f489d2c6fec8994c642c2ec925eb858727dc7b ("rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs")
>>
>> abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
>> ---------------  -------------------------  
>>      12654 ~ 0%      -1.5%      12470 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>>      12654 ~ 0%      -1.5%      12470 ~ 0%  TOTAL netperf.Throughput_tps
> 
> Out of curiosity, what parameters do you use for this test?  In my

The cmdline for this test is:
netperf -t TCP_CRR -c -C -l 300

> piddling around with high frequency switching loads, they tend to have
> too much build to build and boot to boot variance to track 1.5%.

The actual results are not 100% stable, here is the values of the 5
runs:

$ cat [0-4]/netperf.json 
{
  "netperf.Throughput_tps": [
    12674.061666666668
  ]
}{
  "netperf.Throughput_tps": [
    12705.6325
  ]
}{
  "netperf.Throughput_tps": [
    12621.97333333333
  ]
}{
  "netperf.Throughput_tps": [
    12604.785000000002
  ]
}{
  "netperf.Throughput_tps": [
    12664.158333333333
  ]

I suppose the way the stddev% is calculated by first calculating the
average and then compare the individual value with the average.
Fengguang, is this correct?

Thanks,
Aaron
