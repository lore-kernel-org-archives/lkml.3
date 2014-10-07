Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaJGPZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:25:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaJGPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:25:33 -0400
Date: Tue, 7 Oct 2014 17:25:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 14/16] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20141007152528.GD5850@twins.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-15-git-send-email-kan.liang@intel.com>
 <20140924142110.GG2805@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770160F9C0@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770160F9C0@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 03:00:43AM +0000, Liang, Kan wrote:
> 
> 
> >
> > On Wed, Sep 10, 2014 at 10:09:11AM -0400, kan.liang@intel.com wrote:
> > > From: Kan Liang <kan.liang@intel.com>
> > >
> > > If a task specific event wants user space callchain but does not want
> > > branch stack sampling, enable the LBR call stack facility implicitly.
> > > The LBR call stack facility can help perf to get user space callchain
> > > in case of there is no frame pointer.
> > >
> > > Note: this feature only affects how to get user callchain. The kernel
> > > callchain is always got by frame pointers.
> >
> > Yeah, don't like this either. Suppose you have sane userspace (with
> > framepointers enabled) then you're now loosing the better option.
> 
> FP is the first option. This patch tries to enable LBR call stack facility implicitly.
> Only when FP disabled or failed, we try to use LBR call stack.
> Please refer to the previous patch https://lkml.org/lkml/2014/9/10/376

Still makes for an entirely unpredictable situation. That way you never
quite know where your data came from.
