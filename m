Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaD3GTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:19:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:20768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaD3GTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:19:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,956,1389772800"; 
   d="scan'208";a="532233454"
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] lib/spinlock_debug: avoid one thread can not obtain the
 spinlock for a long time.
Thread-Topic: [PATCH] lib/spinlock_debug: avoid one thread can not obtain
 the spinlock for a long time.
Thread-Index: AQHPZDpRqFXAm2x1Dka7tvjLa5inepsprVZA
Date: Wed, 30 Apr 2014 06:17:48 +0000
Message-ID: <FA47D36D6EC9FE4CB463299737C09B9901C14B96@shsmsx102.ccr.corp.intel.com>
References: <1398877471.21870.6.camel@wxm-ubuntu>
 <20140430060625.GV11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140430060625.GV11096@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Peter
	If we wait the end of loop as loops_per_jiffy. 
It may last more than 130s and local IRQ disabled at interval 
which may cause Hard LOCKUP. We break out in 1 second and
dump the stack for debug.

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, April 30, 2014 2:06 PM
> To: Wang, Xiaoming
> Cc: mingo@redhat.com; linux-kernel@vger.kernel.org; Liu, Chuansheng
> Subject: Re: [PATCH] lib/spinlock_debug: avoid one thread can not obtain
> the spinlock for a long time.
> 
> On Wed, Apr 30, 2014 at 01:04:31PM -0400, Wang, Xiaoming wrote:
> > loops_per_jiffy is larger than expectation that possible causes one
> > thread can not obtain the spin lock for a long time.
> > So use cpu_clock() to reach timeout in one second which can avoid
> HARD
> > LOCKUP.
> 
> This is just not making sense.. one thing is broken so then you tape on
> another? Fix the first already.
> 
> Also, why do you care?
