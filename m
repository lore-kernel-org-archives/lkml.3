Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaCFU1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:27:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:61813 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaCFU1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:27:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,602,1389772800"; 
   d="scan'208";a="487450318"
Date: Thu, 6 Mar 2014 22:27:05 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org
Subject: preempt_check_resched() gone?
Message-ID: <20140306202705.GD3852@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It appears preempt_check_resched() is no longer available for modules
since [1]. So now I'm left wondering what is one supposed to use after
local_irq_enable(). Documentation/preempt-locking.txt still says one
should do a check, but the tool to do that was taken away.

In case you're wondering why I even need local_irq_enable(), see [2].
So I'm trying to make sure a bunch of double buffered registers get
latched by the hardware during the same display frame. The hardware
will latch the registers at a specific point during the display
refresh cycle, and so I need to avoid writing the registers when
we're too close to that point to make sure all of the registers will
latch the new values at the same time.

[1]
commit 62b94a08da1bae9d187d49dfcd6665af393750f8
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Nov 20 16:52:19 2013 +0100

    sched/preempt: Take away preempt_enable_no_resched() from modules
    
    Discourage drivers/modules to be creative with preemption.
    
    Sadly all is implemented in macros and inline so if they want to do
    evil they still can, but at least try and discourage some.

[2] http://lists.freedesktop.org/archives/intel-gfx/2014-February/040161.html

-- 
Ville Syrjälä
Intel OTC
