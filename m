Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3IJH3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:29:50 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:51689 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3IJH3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:29:48 -0400
MIME-Version: 1.0
In-Reply-To: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
References: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
Date: Tue, 10 Sep 2013 09:29:48 +0200
Message-ID: <CAFrcx1kLVgAT-2AjWX7vz1ykYf84qFy67M7tyKnJMCYodAihSA@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf: parse the dwarf backtrace info from
 .debug_frame section
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Patch Tracking <patches@linaro.org>, Jean Pihet <jean.pihet@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

FYI a wiki page has been added for perf-libunwind, at
https://wiki.linaro.org/LEG/Engineering/TOOLS/perf-libunwind

Any feedback is welcome!

Cheers,
Jean

On 9 September 2013 12:00, Jean Pihet <jean.pihet@linaro.org> wrote:
> On ARM the debug info is not present in the .eh_frame sections but
> in .debug_frame instead, in dwarf format.
>
> This patch set uses libunwind to load and parse the dwarf debug info from
> the .debug_frame section if no .eh_frame_hdr section is found; also it
> sets the hooks in the perf_regs and libunwind code for ARMv7.
>
> Dependencies:
>  . if present, libunwind >= 1.1 is needed to prevent a segfault when
>    parsing the dwarf info,
>  . libunwind needs to be configured with --enable-debug-frame
>    to prevent a linkage error. Note: --enable-debug-frame is automatically
>    selected on ARM).
>
> The generated perf has been tested on ARMv7/OMAP4 and x86_64, using the
> following commands:
>  perf record -g [dwarf] -- <binary>
>  perf report --sort symbol --call-graph --stdio
>
>
> Jean Pihet (1):
>   perf: parse the .debug_frame section in case .eh_frame is not present
>
> Will Deacon (2):
>   ARM: perf: add support for perf registers API
>   ARM: perf: wire up perf_regs and unwind support for ARM
>
>  arch/arm/Kconfig                        |  2 +
>  arch/arm/include/uapi/asm/Kbuild        |  1 +
>  arch/arm/include/uapi/asm/perf_regs.h   | 23 +++++++++++
>  arch/arm/kernel/Makefile                |  1 +
>  arch/arm/kernel/perf_regs.c             | 30 ++++++++++++++
>  tools/perf/arch/arm/Makefile            |  3 ++
>  tools/perf/arch/arm/include/perf_regs.h | 54 +++++++++++++++++++++++++
>  tools/perf/arch/arm/util/unwind.c       | 48 ++++++++++++++++++++++
>  tools/perf/config/Makefile              |  9 +++--
>  tools/perf/util/unwind.c                | 71 +++++++++++++++++++++++++--------
>  10 files changed, 223 insertions(+), 19 deletions(-)
>  create mode 100644 arch/arm/include/uapi/asm/perf_regs.h
>  create mode 100644 arch/arm/kernel/perf_regs.c
>  create mode 100644 tools/perf/arch/arm/include/perf_regs.h
>  create mode 100644 tools/perf/arch/arm/util/unwind.c
>
> --
> 1.7.11.7
>
