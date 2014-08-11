Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaHKBXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:23:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:14490 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaHKBXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:23:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,838,1400050800"; 
   d="scan'208";a="586224679"
Date: Mon, 11 Aug 2014 09:23:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
Message-ID: <20140811012340.GA6593@localhost>
References: <20140810044127.GB11810@localhost>
 <20140810075915.GR9918@twins.programming.kicks-ass.net>
 <20140810105413.GA29451@localhost>
 <20140810150503.GV9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140810150503.GV9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 05:05:03PM +0200, Peter Zijlstra wrote:
> On Sun, Aug 10, 2014 at 06:54:13PM +0800, Fengguang Wu wrote:
> > The "brickland1/aim7/6000-page_test" is the test case part.
> > 
> > The "TOTAL XXX" is the metric part. One test run may generate lots of
> > metrics, reflecting different aspect of the system dynamics.
> > 
> > This view may be easier to read, by grouping the metrics by test case.
> 
> Right, at least that makes more sense.
> 
> > test case: brickland1/aim7/6000-page_test
> 
> Ok, so next question, what is a brickland? I suspect its a machine of
> sorts, seeing how some others had wsm in that part of the test. Now I
> know what a westmere is, but I've never heard of a brickland.

As Ingo says, it's the "Brickland" platform with "Ivy Bridge-EX" CPU.

Sorry this part can be improved -- I'll add description of the test
boxes in future reports.

> Please describe the machine, this is a topology patch, so we need to
> know the topology of the affected machines.

Here they are. If you need more (or less) information (now and future),
please let me know.

brickland1: Brickland Ivy Bridge-EX
Memory: 128G

brickland3: Brickland Ivy Bridge-EX
Memory: 512G
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                120
On-line CPU(s) list:   0-119
Thread(s) per core:    2
Core(s) per socket:    15
Socket(s):             4
NUMA node(s):          4
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 62
Stepping:              7
CPU MHz:               3192.875
BogoMIPS:              5593.49
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              38400K
NUMA node0 CPU(s):     0-14,60-74
NUMA node1 CPU(s):     15-29,75-89
NUMA node2 CPU(s):     30-44,90-104
NUMA node3 CPU(s):     45-59,105-119

lkp-snb01: Sandy Bridge-EP
Memory: 32G
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                32
On-line CPU(s) list:   0-31
Thread(s) per core:    2
Core(s) per socket:    8
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 45
Stepping:              6
CPU MHz:               3498.820
BogoMIPS:              5391.31
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              20480K
NUMA node0 CPU(s):     0-7,16-23
NUMA node1 CPU(s):     8-15,24-31

wsm: Westmere
Memory: 6G
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                12
On-line CPU(s) list:   0-11
Thread(s) per core:    2
Core(s) per socket:    6
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 44
Stepping:              2
CPU MHz:               3458.000
BogoMIPS:              6756.46
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              12288K
NUMA node0 CPU(s):     0-11

lkp-nex04: Nehalem-EX
Memory: 256G
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                64
On-line CPU(s) list:   0-63
Thread(s) per core:    2
Core(s) per socket:    8
Socket(s):             4
NUMA node(s):          4
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 46
Stepping:              6
CPU MHz:               2262.000
BogoMIPS:              4521.30
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              24576K
NUMA node0 CPU(s):     0-7,32-39
NUMA node1 CPU(s):     8-15,40-47
NUMA node2 CPU(s):     16-23,48-55
NUMA node3 CPU(s):     24-31,56-63

nhm4: Nehalem
Memory: 4G
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    2
Core(s) per socket:    4
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 26
Stepping:              4
CPU MHz:               3193.000
BogoMIPS:              6400.40
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              8192K
NUMA node0 CPU(s):     0-7

Thanks,
Fengguang
