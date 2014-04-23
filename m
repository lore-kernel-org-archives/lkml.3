Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaDWRsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:48:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:39541 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbaDWRr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,913,1389772800"; 
   d="scan'208";a="526401944"
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Bugfix] sched: fix possible invalid memory access caused by
 CPU hot-addition
Thread-Topic: [Bugfix] sched: fix possible invalid memory access caused by
 CPU hot-addition
Thread-Index: AQHPXes1Qjl1X5tgj0C+YUEy+BJBwpsdv3yAgAE2H4CAAC6pgIAABUiAgABRbRA=
Date: Wed, 23 Apr 2014 17:46:26 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F327EB605@ORSMSX114.amr.corp.intel.com>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
 <20140422081515.GF11182@twins.programming.kicks-ass.net>
 <53572939.7020509@linux.intel.com>
 <20140423053213.GV26782@laptop.programming.kicks-ass.net>
 <20140423055107.GB1429@laptop.programming.kicks-ass.net>
In-Reply-To: <20140423055107.GB1429@laptop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 1) Handle CPU hot-addition event
> > > 1.a) gather platform specific information
> > > 1.b) associate hot-added CPU with a node
> > > 1.c) create CPU device
> > > 2) User online hot-added CPUs through sysfs:
> > > 2.a)	cpu_up()
> > > 2.b)		->try_online_node()
> > > 2.c)			->hotadd_new_pgdat()
> > > 2.d)			->node_set_online()
> > > 
> > > So between 1.b and 2.c, kmalloc_node(nid) may cause invalid
> > > memory access without the node_online(nid) check.
> > 
> > Any why was all this not in the Changelog?
>
> Also, do explain what kind of hardware you needed to trigger this. This
> code has been like this for a good while.

With your proposed fix in place the allocations will succeed - but they
will be done from other nodes ... and this cpu will have to do a remote
NUMA access for the rest of time.

It would be better to switch the order above - add the memory first,
then add the cpus.  Is that possible?

-Tony
