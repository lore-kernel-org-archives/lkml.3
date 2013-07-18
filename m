Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3GRI34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:29:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56958 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3GRI3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:29:54 -0400
Date: Thu, 18 Jul 2013 10:29:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
Message-ID: <20130718082947.GB27075@twins.programming.kicks-ass.net>
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 01:36:07PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Compare to old atom, Silvermont has offcore and has more events
> that support PEBS.
> 
> Silvermont has two offcore response configuration MSRs, but the
> event code for OFFCORE_RSP_1 is 0x02b7. To avoid complicating
> intel_fixup_er(), use INTEL_UEVENT_EXTRA_REG to define offcore
> MSRs. So intel_fixup_er() can find the code for OFFCORE_RSP_1
> by x86_pmu.extra_regs[1].event.

Please split this in two patches; one reworking the OFFCORE_RSP stuff;
one adding slm support.
