Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaJGQEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:04:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:56218 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbaJGQEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:04:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="396640624"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: RE: [PATCH V5 14/16] perf, x86: enable LBR callstack when recording
 callchain
Thread-Topic: [PATCH V5 14/16] perf, x86: enable LBR callstack when
 recording callchain
Thread-Index: AQHPzQDlODabdJWPqUe8OhPIgqI+2ZwP5XUAgBOaQvCAAOYDAIAAjkkA
Date: Tue, 7 Oct 2014 16:04:11 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016111A4@SHSMSX103.ccr.corp.intel.com>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-15-git-send-email-kan.liang@intel.com>
 <20140924142110.GG2805@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770160F9C0@SHSMSX103.ccr.corp.intel.com>
 <20141007152528.GD5850@twins.programming.kicks-ass.net>
In-Reply-To: <20141007152528.GD5850@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> On Tue, Oct 07, 2014 at 03:00:43AM +0000, Liang, Kan wrote:
> >
> >
> > >
> > > On Wed, Sep 10, 2014 at 10:09:11AM -0400, kan.liang@intel.com wrote:
> > > > From: Kan Liang <kan.liang@intel.com>
> > > >
> > > > If a task specific event wants user space callchain but does not
> > > > want branch stack sampling, enable the LBR call stack facility implicitly.
> > > > The LBR call stack facility can help perf to get user space
> > > > callchain in case of there is no frame pointer.
> > > >
> > > > Note: this feature only affects how to get user callchain. The
> > > > kernel callchain is always got by frame pointers.
> > >
> > > Yeah, don't like this either. Suppose you have sane userspace (with
> > > framepointers enabled) then you're now loosing the better option.
> >
> > FP is the first option. This patch tries to enable LBR call stack facility implicitly.
> > Only when FP disabled or failed, we try to use LBR call stack.
> > Please refer to the previous patch https://lkml.org/lkml/2014/9/10/376
> 
> Still makes for an entirely unpredictable situation. That way you never quite
> know where your data came from.

But the problem is that we don't know if FP works in advance. We can only
check during runtime. So we have to keep the LBR running.
The process is  fixed. The FP will be checked first.
Only FP failed, LBR data is used. 
If the user want to know where the data come from, we may implement
a flag for user perf tool. 

Kan
