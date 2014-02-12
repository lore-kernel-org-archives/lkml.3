Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaBLIrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:47:19 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:61814 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaBLIrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:47:17 -0500
MIME-Version: 1.0
In-Reply-To: <1391451509-31265-1-git-send-email-jean.pihet@linaro.org>
References: <1391451509-31265-1-git-send-email-jean.pihet@linaro.org>
Date: Wed, 12 Feb 2014 09:47:17 +0100
Message-ID: <CAFrcx1mBWnO7mivQtGY1qLfd=KwV4ehyZoq0tV7buMiWKrTqrQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] perf: AARCH64 arch support
From: Jean Pihet <jean.pihet@linaro.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Patch Tracking <patches@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Ping on the series. Is this OK for inclusion?

Regards,
Jean

On 3 February 2014 19:18, Jean Pihet <jean.pihet@linaro.org> wrote:
> Add AARCH64 specific support. This includes the following:
> - AARCH64 perf registers definition and hooks,
> - compat mode registers use, i.e. profiling a 32-bit binary on
>    a 64-bit system,
> - unwinding using the dwarf information from the .debug_frame
>    section of the ELF binary,
> - unwinding using the frame pointer information; in 64-bit and
>    compat modes.
>
> Notes:
> - the tools/perf change is submitted separately on LKML,
> - support for unwinding using the dwarf information in compat
> mode requires some changes to the libunwind code. Those changes
> have been submitted on the libunwind ML and are in discussion.
>
> Tested on ARMv7, ARMv8 and x86_64 platforms. The compat mode has been
> tested on ARMv8 using statically built 32-bit binaries.
>
>
> Jean Pihet (3):
>   ARM64: perf: add support for perf registers API
>   ARM64: perf: add support for frame pointer unwinding in compat mode
>   ARM64: perf: support dwarf unwinding in compat mode
>
>  arch/arm64/Kconfig                      |  2 +
>  arch/arm64/include/asm/compat.h         |  2 +-
>  arch/arm64/include/asm/ptrace.h         |  3 +-
>  arch/arm64/include/uapi/asm/Kbuild      |  1 +
>  arch/arm64/include/uapi/asm/perf_regs.h | 40 ++++++++++++++++++
>  arch/arm64/kernel/Makefile              |  1 +
>  arch/arm64/kernel/perf_event.c          | 75 +++++++++++++++++++++++++++++----
>  arch/arm64/kernel/perf_regs.c           | 44 +++++++++++++++++++
>  8 files changed, 158 insertions(+), 10 deletions(-)
>  create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
>  create mode 100644 arch/arm64/kernel/perf_regs.c
>
> --
> 1.7.11.7
>
