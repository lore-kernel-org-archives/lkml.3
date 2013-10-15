Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab3JOMhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:37:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55098 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3JOMhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:37:38 -0400
Date: Tue, 15 Oct 2013 14:37:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar (mingo@kernel.org)" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: Re: Panic and page fault in loop during handling NMI backtrace
 handler
Message-ID: <20131015123717.GJ10651@twins.programming.kicks-ass.net>
References: <27240C0AC20F114CBF8149A2696CBE4A01B60835@SHSMSX101.ccr.corp.intel.com>
 <20131015121849.GA29884@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015121849.GA29884@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 02:18:53PM +0200, Frederic Weisbecker wrote:
> On Tue, Oct 15, 2013 at 02:01:04AM +0000, Liu, Chuansheng wrote:
> > We meet one issue that during trigger all CPU backtrace, but during in the NMI handler arch_trigger_all_cpu_backtrace_handler,
> > It hit the PAGE fault, then PAGE fault is in loop, at last the thread stack overflow, and system panic.
> > 
> > Anyone can give some help? Thanks.
> 
> Looks like we re-enter the fault several times. On x86-32, NMIs can
> fault if they dereference vmalloc'ed area. I wonder if the module thing
> we lookup in the NMI is stored on some vmalloc'ed area.

IIRC modules are indeed allocated using vmalloc. See module_alloc()
using vmalloc_exec()
