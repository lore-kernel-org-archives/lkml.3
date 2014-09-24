Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaIXNzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:55:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:41145 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIXNzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:55:17 -0400
Date: Wed, 24 Sep 2014 15:55:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 10/16] perf, core: simplify need branch stack check
Message-ID: <20140924135514.GE2805@worktop.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-11-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358153-421-11-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:09:07AM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> event->attr.branch_sample_type is non-zero no matter branch stack
> is enabled explicitly or is enabled implicitly. we can use it to
> replace intel_pmu_needs_lbr_smpl(). This avoids duplicating code
> that implicitly enables the LBR.
> 

Please extend the changelog such that it's obvious this is correct. This
is the second time I've had to look how this works out for PEBS.
