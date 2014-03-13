Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaCMLB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:01:27 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62221 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaCMLBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:01:25 -0400
Date: Thu, 13 Mar 2014 12:01:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, will.deacon@arm.com,
        acme@ghostprotocols.net, jean.pihet@linaro.org, jolsa@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] ARM64, perf: Add support for perf registers API
Message-ID: <20140313110121.GA9816@gmail.com>
References: <1391451509-31265-2-git-send-email-jean.pihet@linaro.org>
 <tip-1acfb01a43db9d8cde2d4c1d51746bae0b46b06b@git.kernel.org>
 <20140313101907.GC17308@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313101907.GC17308@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> Hi Ingo,
> 
> On Thu, Mar 13, 2014 at 12:27:45AM -0700, tip-bot for Jean Pihet wrote:
> > Commit-ID:  1acfb01a43db9d8cde2d4c1d51746bae0b46b06b
> > Gitweb:     http://git.kernel.org/tip/1acfb01a43db9d8cde2d4c1d51746bae0b46b06b
> > Author:     Jean Pihet <jean.pihet@linaro.org>
> > AuthorDate: Mon, 3 Feb 2014 19:18:27 +0100
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 12 Mar 2014 13:45:28 +0100
> > 
> > ARM64, perf: Add support for perf registers API
> > 
> > This patch implements the functions required for the perf
> > registers API, allowing the perf tool to interface kernel
> > register dumps with libunwind in order to provide userspace
> > backtracing. Compat mode is also supported.
> > 
> > Only the general purpose user space registers are exported,
> > i.e.:  PERF_REG_ARM_X0,
> >  ...
> >  PERF_REG_ARM_X28,
> >  PERF_REG_ARM_FP,
> >  PERF_REG_ARM_LR,
> >  PERF_REG_ARM_SP,
> >  PERF_REG_ARM_PC
> > and not the PERF_REG_ARM_V* registers.
> > 
> > Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> > Acked-by: Will Deacon <will.deacon@arm.com>
> > Cc: Arnaldo <acme@ghostprotocols.net>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: patches@linaro.org
> > Cc: linaro-kernel@lists.linaro.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Link: http://lkml.kernel.org/r/1391451509-31265-2-git-send-email-jean.pihet@linaro.org
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > ---
> >  arch/arm64/Kconfig                      |  2 ++
> >  arch/arm64/include/asm/ptrace.h         |  1 +
> >  arch/arm64/include/uapi/asm/Kbuild      |  1 +
> >  arch/arm64/include/uapi/asm/perf_regs.h | 40 ++++++++++++++++++++++++++++++
> >  arch/arm64/kernel/Makefile              |  1 +
> >  arch/arm64/kernel/perf_regs.c           | 44 +++++++++++++++++++++++++++++++++
> >  6 files changed, 89 insertions(+)
> 
> As I replied to Jean yesterday, I merged the arch/arm64 patches already
> in the arm64 tree. Is it late to drop them from tip (and avoid potential
> conflicts)?
> 
> But please take the perf tools patch (tools/perf/arch/arm64/...).

Well, I merged them so that the tooling bits can be tested on top of 
that and merged as well.

Anyway, I dropped them, they were still the tail of tip:perf/core.

Thanks,

	Ingo
