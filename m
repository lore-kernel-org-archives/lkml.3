Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaD3HnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:43:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:34490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaD3HnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:43:11 -0400
Date: Wed, 30 Apr 2014 09:43:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] lib/spinlock_debug: avoid one thread can not obtain the
 spinlock for a long time.
Message-ID: <20140430074307.GX11096@twins.programming.kicks-ass.net>
References: <1398877471.21870.6.camel@wxm-ubuntu>
 <20140430060625.GV11096@twins.programming.kicks-ass.net>
 <FA47D36D6EC9FE4CB463299737C09B9901C14B96@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA47D36D6EC9FE4CB463299737C09B9901C14B96@shsmsx102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 06:17:48AM +0000, Wang, Xiaoming wrote:
> Dear Peter
> 	If we wait the end of loop as loops_per_jiffy. 
> It may last more than 130s and local IRQ disabled at interval 
> which may cause Hard LOCKUP. We break out in 1 second and
> dump the stack for debug.

Yeah, so? That makes shoddy engineering alright then?

So either fix the loops_per_jiffy thing, it is supposed to wait for 1
second after all, or explain why its broken and entirely replace it.

What you do not do is make a loop with 2 differently broken timeouts and
hope one works.
