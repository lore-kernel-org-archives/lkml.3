Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaCNIot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:44:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35465 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaCNIoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:44:46 -0400
Date: Fri, 14 Mar 2014 09:44:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, mingo@elte.hu,
        ak@linux.intel.com, zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL
 PMU.
Message-ID: <20140314084429.GO27965@twins.programming.kicks-ass.net>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394739386-22260-1-git-send-email-venkateshs@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:36:26PM -0700, Venkatesh Srinivas wrote:
> CPUs which should support the RAPL counters according to
> Family/Model/Stepping may still issue #GP when attempting to access
> the RAPL MSRs. This may happen when Linux is running under KVM and
> we are passing-through host F/M/S data, for example. Use rdmsrl_safe
> to first access the RAPL_POWER_UNIT MSR; if this fails, do not
> attempt to use this PMU.

This kvm thing is getting tedious :-(
