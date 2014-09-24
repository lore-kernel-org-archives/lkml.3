Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaIXOPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:15:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46455 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaIXOPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:15:13 -0400
Date: Wed, 24 Sep 2014 16:15:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 11/16] perf, core: Pass perf_sample_data to
 perf_callchain()
Message-ID: <20140924141507.GF2805@worktop.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-12-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358153-421-12-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:09:08AM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> Haswell has a new feature that utilizes the existing Last Branch Record
> facility to record call chains. When the feature is enabled, function
> call will be collected as normal, but as return instructions are
> executed the last captured branch record is popped from the on-chip LBR
> registers.
> The LBR call stack facility can help perf to get call chains of progam
> without frame pointer.
> 
> This patch modifies various architectures' perf_callchain() to accept
> perf sample data. Later patch will add code that use the sample data to
> get call chains.

So I don't like this. Why not use the regular PERF_SAMPLE_BRANCH_STACK
output to generate the stuff from? We already have two different means,
with different transport, for callchains anyhow, so a third really won't
matter.
