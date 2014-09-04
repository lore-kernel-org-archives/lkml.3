Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaIDPrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:47:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:47337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaIDPrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:47:14 -0400
Date: Thu, 4 Sep 2014 17:47:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: Re: [PATCH 3/3] cpuidle: Using the wake_up_all_idle_cpus() to wake
 up all idle cpus
Message-ID: <20140904154710.GH346@worktop.programming.kicks-ass.net>
References: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
 <1409815075-4180-3-git-send-email-chuansheng.liu@intel.com>
 <540862AA.7060907@linaro.org>
 <27240C0AC20F114CBF8149A2696CBE4A01E6B3E3@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01E6B3E3@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 01:39:38PM +0000, Liu, Chuansheng wrote:
> > So IIUC, kick_all_cpus_sync is a broken function, right ?

> kick_all_cpus_sync has other callers, and those other callers want the
> old behavior.  I think this should be a new function.

Correct, things like arch/powerpc/mm/pgtable_64.c:pmdp_clear_flush()
really want the old behaviour. It basically uses
local_irq_disable()/local_irq_enable() vs kick_all_cpus_sync() as a RCU
like serialization primitive.
