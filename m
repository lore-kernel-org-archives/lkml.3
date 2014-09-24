Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaIXOVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:21:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIXOVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:21:19 -0400
Date: Wed, 24 Sep 2014 16:21:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 14/16] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20140924142110.GG2805@worktop.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-15-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358153-421-15-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:09:11AM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> If a task specific event wants user space callchain but does not want
> branch stack sampling, enable the LBR call stack facility implicitly.
> The LBR call stack facility can help perf to get user space callchain
> in case of there is no frame pointer.
> 
> Note: this feature only affects how to get user callchain. The kernel
> callchain is always got by frame pointers.

Yeah, don't like this either. Suppose you have sane userspace (with
framepointers enabled) then you're now loosing the better option.
