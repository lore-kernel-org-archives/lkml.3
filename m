Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaLDO2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:28:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbaLDO2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:28:51 -0500
Date: Thu, 4 Dec 2014 15:23:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, namhyung@kernel.org
Subject: Re: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Message-ID: <20141204142330.GB10406@krava.brq.redhat.com>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:06:51AM -0500, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> This is the user space patch for Haswell LBR call stack support.
> For many profiling tasks we need the callgraph. For example we often
> need to see the caller of a lock or the caller of a memcpy or other
> library function to actually tune the program. Frame pointer unwinding
> is efficient and works well. But frame pointers are off by default on
> 64bit code (and on modern 32bit gccs), so there are many binaries around
> that do not use frame pointers. Profiling unchanged production code is
> very useful in practice. On some CPUs frame pointer also has a high
> cost. Dwarf2 unwinding also does not always work and is extremely slow
> (upto 20% overhead).
> 
> Haswell has a new feature that utilizes the existing Last Branch Record
> facility to record call chains. When the feature is enabled, function
> call will be collected as normal, but as return instructions are
> executed the last captured branch record is popped from the on-chip LBR
> registers. The LBR call stack facility provides an alternative to get
> callgraph. It has some limitations too, but should work in most cases
> and is significantly faster than dwarf. Frame pointer unwinding is still
> the best default, but LBR call stack is a good alternative when nothing
> else works.
> 
> Please find the kernel part patch at https://lkml.org/lkml/2014/11/6/432
> 
> Changes since v1
>  - Update help document
>  - Force exclude_user to 0 with warning in LBR call stack
>  - Dump both lbr and fp info when report -D
>  - Reconstruct thread__resolve_callchain_sample and split it into two patches
>  - Use has_branch_callstack function to check LBR call stack available
> 
> Changes since v2
>  - Rebase to 025ce5d33373
> 
> Changes since v3
>  - Rebase to cc502c23aadf
>  - Separated function for lbr call stack sample resolve and print
>  - Some minor changes according to comments
> 
> Changes since V4
>  - Rebase to 09a6a1b
>  - Falling back to framepointers if LBR not available, and warning user

looks ok to me..

I'll test it once I get hands on Haswel server again, I guess we
wait for the kernel change to go in first anyway, right?

thanks,
jirka
