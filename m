Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3LQKpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:45:40 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:60716 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3LQKpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:45:38 -0500
Date: Tue, 17 Dec 2013 11:45:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: jean.pihet@linaro.org, Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Arnaldo <acme@ghostprotocols.net>, Will Deacon <will.deacon@arm.com>,
        patches@linaro.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 0/3] ARM64: add perf support
Message-ID: <20131217104534.GA27383@gmail.com>
References: <52af2f21.41590e0a.0251.ffffd94c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52af2f21.41590e0a.0251.ffffd94c@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* jean.pihet@linaro.org <jean.pihet@linaro.org> wrote:

> From: Jean Pihet <jean.pihet@linaro.org>
> 
> Add perf support for the AARCH64 architecture. This includes the
> support for:
> - AARCH64 perf registers definition and hooks,
> - compat mode registers use, i.e. profiling a 32-bit binary on
>    a 64-bit system,
> - unwinding using the dwarf information from the .debug_frame
>    section of the ELF binary; only in 64-bit mode,
> - unwinding using the frame pointer information; in 64-bit and
>    compat modes.
> 
> ToDo:
> - add support for unwinding using the dwarf information in compat
>    mode. This requires some changes to the libunwind code.
> 
> Tested on ARMv7 and ARMv8 platforms. The compat mode has been tested
> on ARMv8 using statically built 32-bit binaries.
> 
> 
> Jean Pihet (3):
>   ARM64: perf: add support for perf registers API
>   ARM64: perf: wire up perf_regs and unwind support
>   ARM64: perf: add support for frame pointer unwinding in compat mode
> 
>  arch/arm64/Kconfig                        |  2 +
>  arch/arm64/include/asm/ptrace.h           |  1 +
>  arch/arm64/include/uapi/asm/Kbuild        |  1 +
>  arch/arm64/include/uapi/asm/perf_regs.h   | 40 ++++++++++++++
>  arch/arm64/kernel/Makefile                |  1 +
>  arch/arm64/kernel/perf_event.c            | 75 +++++++++++++++++++++++---
>  arch/arm64/kernel/perf_regs.c             | 46 ++++++++++++++++
>  tools/perf/arch/arm64/Makefile            |  7 +++
>  tools/perf/arch/arm64/include/perf_regs.h | 88 +++++++++++++++++++++++++++++++
>  tools/perf/arch/arm64/util/dwarf-regs.c   | 81 ++++++++++++++++++++++++++++
>  tools/perf/arch/arm64/util/unwind.c       | 82 ++++++++++++++++++++++++++++
>  tools/perf/config/Makefile                |  8 ++-
>  12 files changed, 423 insertions(+), 9 deletions(-)
>  create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
>  create mode 100644 arch/arm64/kernel/perf_regs.c
>  create mode 100644 tools/perf/arch/arm64/Makefile
>  create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
>  create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
>  create mode 100644 tools/perf/arch/arm64/util/unwind.c

Arnaldo, AFAICS the main merging complexity will probably be on the 
perf tooling side, so if you are happy with these bits, mind picking 
them up into your tree?

Thanks,

	Ingo
