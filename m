Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaJGDAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 23:00:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:35562 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaJGDAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 23:00:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,666,1406617200"; 
   d="scan'208";a="482411900"
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
Thread-Index: AQHPzQDlODabdJWPqUe8OhPIgqI+2ZwP5XUAgBOaQvA=
Date: Tue, 7 Oct 2014 03:00:43 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770160F9C0@SHSMSX103.ccr.corp.intel.com>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-15-git-send-email-kan.liang@intel.com>
 <20140924142110.GG2805@worktop.programming.kicks-ass.net>
In-Reply-To: <20140924142110.GG2805@worktop.programming.kicks-ass.net>
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
> On Wed, Sep 10, 2014 at 10:09:11AM -0400, kan.liang@intel.com wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > If a task specific event wants user space callchain but does not want
> > branch stack sampling, enable the LBR call stack facility implicitly.
> > The LBR call stack facility can help perf to get user space callchain
> > in case of there is no frame pointer.
> >
> > Note: this feature only affects how to get user callchain. The kernel
> > callchain is always got by frame pointers.
>
> Yeah, don't like this either. Suppose you have sane userspace (with
> framepointers enabled) then you're now loosing the better option.

FP is the first option. This patch tries to enable LBR call stack facility implicitly.
Only when FP disabled or failed, we try to use LBR call stack.
Please refer to the previous patch https://lkml.org/lkml/2014/9/10/376

Kan

