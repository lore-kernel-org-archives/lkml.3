Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaHLO6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:58:38 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46431 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaHLO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:58:36 -0400
Message-ID: <53ea2b9a.a7d7b60a.4971.ffffda2c@mx.google.com>
X-Google-Original-Message-ID: 582bdf55-969a-4585-a109-0658f0557f9a@gmail.com>
Date: Tue, 12 Aug 2014 09:57:28 -0500
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
In-Reply-To: <20140811012340.GA6593@localhost>
References: <20140810044127.GB11810@localhost>
 <20140810075915.GR9918@twins.programming.kicks-ass.net>
 <20140810105413.GA29451@localhost>
 <20140810150503.GV9918@twins.programming.kicks-ass.net>
 <20140811012340.GA6593@localhost>
From: kodiak furr <boxerspam1@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: lkp@01.org, Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7CEwg5h014344

.

Sent using Boxer

On Aug 10, 2014 8:23 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> On Sun, Aug 10, 2014 at 05:05:03PM +0200, Peter Zijlstra wrote: 
> > On Sun, Aug 10, 2014 at 06:54:13PM +0800, Fengguang Wu wrote: 
> > > The "brickland1/aim7/6000-page_test" is the test case part. 
> > > 
> > > The "TOTAL XXX" is the metric part. One test run may generate lots of 
> > > metrics, reflecting different aspect of the system dynamics. 
> > > 
> > > This view may be easier to read, by grouping the metrics by test case. 
> > 
> > Right, at least that makes more sense. 
> > 
> > > test case: brickland1/aim7/6000-page_test 
> > 
> > Ok, so next question, what is a brickland? I suspect its a machine of 
> > sorts, seeing how some others had wsm in that part of the test. Now I 
> > know what a westmere is, but I've never heard of a brickland. 
>
> As Ingo says, it's the "Brickland" platform with "Ivy Bridge-EX" CPU. 
>
> Sorry this part can be improved -- I'll add description of the test 
> boxes in future reports. 
>
> > Please describe the machine, this is a topology patch, so we need to 
> > know the topology of the affected machines. 
>
> Here they are. If you need more (or less) information (now and future), 
> please let me know. 
>
> brickland1: Brickland Ivy Bridge-EX 
> Memory: 128G 
>
> brickland3: Brickland Ivy Bridge-EX 
> Memory: 512G 
> Architecture:          x86_64 
> CPU op-mode(s):        32-bit, 64-bit 
> Byte Order:            Little Endian 
> CPU(s):                120 
> On-line CPU(s) list:   0-119 
> Thread(s) per core:    2 
> Core(s) per socket:    15 
> Socket(s):             4 
> NUMA node(s):          4 
> Vendor ID:             GenuineIntel 
> CPU family:            6 
> Model:                 62 
> Stepping:              7 
> CPU MHz:               3192.875 
> BogoMIPS:              5593.49 
> Virtualization:        VT-x 
> L1d cache:             32K 
> L1i cache:             32K 
> L2 cache:              256K 
> L3 cache:              38400K 
> NUMA node0 CPU(s):     0-14,60-74 
> NUMA node1 CPU(s):     15-29,75-89 
> NUMA node2 CPU(s):     30-44,90-104 
> NUMA node3 CPU(s):     45-59,105-119 
>
> lkp-snb01: Sandy Bridge-EP 
> Memory: 32G 
> Architecture:          x86_64 
> CPU op-mode(s):        32-bit, 64-bit 
> Byte Order:            Little Endian 
> CPU(s):                32 
> On-line CPU(s) list:   0-31 
> Thread(s) per core:    2 
> Core(s) per socket:    8 
> Socket(s):             2 
> NUMA node(s):          2 
> Vendor ID:             GenuineIntel 
> CPU family:            6 
> Model:                 45 
> Stepping:              6 
> CPU MHz:               3498.820 
> BogoMIPS:              5391.31 
> Virtualization:        VT-x 
> L1d cache:             32K 
> L1i cache:             32K 
> L2 cache:              256K 
> L3 cache:              20480K 
> NUMA node0 CPU(s):     0-7,16-23 
> NUMA node1 CPU(s):     8-15,24-31 
>
> wsm: Westmere 
> Memory: 6G 
> Architecture:          x86_64 
> CPU op-mode(s):        32-bit, 64-bit 
> Byte Order:            Little Endian 
> CPU(s):                12 
> On-line CPU(s) list:   0-11 
> Thread(s) per core:    2 
> Core(s) per socket:    6 
> Socket(s):             1 
> NUMA node(s):          1 
> Vendor ID:             GenuineIntel 
> CPU family:            6 
> Model:                 44 
> Stepping:              2 
> CPU MHz:               3458.000 
> BogoMIPS:              6756.46 
> Virtualization:        VT-x 
> L1d cache:             32K 
> L1i cache:             32K 
> L2 cache:              256K 
> L3 cache:              12288K 
> NUMA node0 CPU(s):     0-11 
>
> lkp-nex04: Nehalem-EX 
> Memory: 256G 
> Architecture:          x86_64 
> CPU op-mode(s):        32-bit, 64-bit 
> Byte Order:            Little Endian 
> CPU(s):                64 
> On-line CPU(s) list:   0-63 
> Thread(s) per core:    2 
> Core(s) per socket:    8 
> Socket(s):             4 
> NUMA node(s):          4 
> Vendor ID:             GenuineIntel 
> CPU family:            6 
> Model:                 46 
> Stepping:              6 
> CPU MHz:               2262.000 
> BogoMIPS:              4521.30 
> Virtualization:        VT-x 
> L1d cache:             32K 
> L1i cache:             32K 
> L2 cache:              256K 
> L3 cache:              24576K 
> NUMA node0 CPU(s):     0-7,32-39 
> NUMA node1 CPU(s):     8-15,40-47 
> NUMA node2 CPU(s):     16-23,48-55 
> NUMA node3 CPU(s):     24-31,56-63 
>
> nhm4: Nehalem 
> Memory: 4G 
> Architecture:          x86_64 
> CPU op-mode(s):        32-bit, 64-bit 
> Byte Order:            Little Endian 
> CPU(s):                8 
> On-line CPU(s) list:   0-7 
> Thread(s) per core:    2 
> Core(s) per socket:    4 
> Socket(s):             1 
> NUMA node(s):          1 
> Vendor ID:             GenuineIntel 
> CPU family:            6 
> Model:                 26 
> Stepping:              4 
> CPU MHz:               3193.000 
> BogoMIPS:              6400.40 
> Virtualization:        VT-x 
> L1d cache:             32K 
> L1i cache:             32K 
> L2 cache:              256K 
> L3 cache:              8192K 
> NUMA node0 CPU(s):     0-7 
>
> Thanks, 
> Fengguang 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in 
> the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 
> Please read the FAQ at  http://www.tux.org/lkml/ 
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
