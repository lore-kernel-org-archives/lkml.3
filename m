Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaLDOt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:49:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:40392 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbaLDOt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:49:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,515,1413270000"; 
   d="scan'208";a="642373172"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
CC: "acme@kernel.org" <acme@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: RE: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Thread-Topic: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Thread-Index: AQHQDkRfJnDNoBLJ7kWTuaSxvb8h+5x++RsAgACMFfA=
Date: Thu, 4 Dec 2014 14:49:52 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
 <20141204142330.GB10406@krava.brq.redhat.com>
In-Reply-To: <20141204142330.GB10406@krava.brq.redhat.com>
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



> On Tue, Dec 02, 2014 at 10:06:51AM -0500, kan.liang@intel.com wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > This is the user space patch for Haswell LBR call stack support.
> > For many profiling tasks we need the callgraph. For example we often
> > need to see the caller of a lock or the caller of a memcpy or other
> > library function to actually tune the program. Frame pointer unwinding
> > is efficient and works well. But frame pointers are off by default on
> > 64bit code (and on modern 32bit gccs), so there are many binaries
> > around that do not use frame pointers. Profiling unchanged production
> > code is very useful in practice. On some CPUs frame pointer also has a
> > high cost. Dwarf2 unwinding also does not always work and is extremely
> > slow (upto 20% overhead).
> >
> > Haswell has a new feature that utilizes the existing Last Branch
> > Record facility to record call chains. When the feature is enabled,
> > function call will be collected as normal, but as return instructions
> > are executed the last captured branch record is popped from the
> > on-chip LBR registers. The LBR call stack facility provides an
> > alternative to get callgraph. It has some limitations too, but should
> > work in most cases and is significantly faster than dwarf. Frame
> > pointer unwinding is still the best default, but LBR call stack is a
> > good alternative when nothing else works.
> >
> > Please find the kernel part patch at
> > https://lkml.org/lkml/2014/11/6/432
> >
> > Changes since v1
> >  - Update help document
> >  - Force exclude_user to 0 with warning in LBR call stack
> >  - Dump both lbr and fp info when report -D
> >  - Reconstruct thread__resolve_callchain_sample and split it into two
> > patches
> >  - Use has_branch_callstack function to check LBR call stack available
> >
> > Changes since v2
> >  - Rebase to 025ce5d33373
> >
> > Changes since v3
> >  - Rebase to cc502c23aadf
> >  - Separated function for lbr call stack sample resolve and print
> >  - Some minor changes according to comments
> >
> > Changes since V4
> >  - Rebase to 09a6a1b
> >  - Falling back to framepointers if LBR not available, and warning
> > user
> 
> looks ok to me..
> 

Thanks for the review.

> I'll test it once I get hands on Haswel server again, I guess we wait for the
> kernel change to go in first anyway, right?
>

I'm not sure, let's ask Peter.

Peter?

Thanks,
Kan
 
> thanks,
> jirka
