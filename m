Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3JaJnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:43:35 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49513 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3JaJn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:43:28 -0400
Date: Thu, 31 Oct 2013 10:43:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: suravee.suthikulpanit@amd.com
Cc: mingo@kernel.org, mingo@redhat.com, jacob.w.shin@gmail.com,
        oleg@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        hpa@zytor.com, tgl@domain.invalid, linux-kernel@vger.kernel.org,
        sherry.hurwitz@amd.com
Subject: Re: [PATCH V5 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint
 Extensions
Message-ID: <20131031094322.GD2253@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:11:05AM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Frederic, this is the rebase of the V4 patch onto the linux-3.12.0-rc3 (linux.git),
> and retest.
> 
> The following patchset enables hardware breakpoint bp_len greater than
> HW_BREAKPOINT_LEN_8 on AMD Family 16h and later.
> 
>   $ perf stat -e mem:0x1000/16:w a.out
>                             ^^
>                             bp_len
> 
> This will count writes to [0x1000 ~ 0x1010)

This interface looks good to me. I mean it seems flexible enough to provide
a range of address that fits anyway whenever the architecture supports breakpoint
ranges through either a length or a mask.

Thanks.

> 
> V5:
> * Rebase onto 3.12.0-rc3.
> * Modify the tools/perf/util/parse-events.y due to change in
>   parse_events_add_breakpoint().
> 
> V4:
> Even more per Oleg's suggestion:
> * Further simplify info->len and info->mask setting switch statement
> 
> V3:
> More per Oleg's suggestion:
> * Use already existing bp_len instead of changing userland API and
>   in kernel turn bp_len into proper AMD hardware breakpoint address
>   mask.
> 
> V2:
> Per Oleg's suggestions:
> * Moved testing of bp_addr_mask to validate_hw_breakpoint()
> * Changed perf tool syntax to mem:<addr>[/addr_mask][:access]
> 
> 
> Jacob Shin (3):
>   perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
>   perf tools: allow user to specify hardware breakpoint bp_len
>   perf tools: add hardware breakpoint bp_len test cases
> 
>  arch/x86/include/asm/cpufeature.h        |  2 ++
>  arch/x86/include/asm/debugreg.h          |  5 +++
>  arch/x86/include/asm/hw_breakpoint.h     |  1 +
>  arch/x86/include/uapi/asm/msr-index.h    |  4 +++
>  arch/x86/kernel/cpu/amd.c                | 19 +++++++++++
>  arch/x86/kernel/hw_breakpoint.c          | 47 +++++++++++----------------
>  tools/perf/Documentation/perf-record.txt |  7 ++--
>  tools/perf/tests/parse-events.c          | 55 ++++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c           | 17 ++++------
>  tools/perf/util/parse-events.h           |  2 +-
>  tools/perf/util/parse-events.l           |  1 +
>  tools/perf/util/parse-events.y           | 26 +++++++++++++--
>  12 files changed, 142 insertions(+), 44 deletions(-)
> 
> -- 
> 1.8.1.2
> 
> 
