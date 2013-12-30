Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab3L3Q2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:28:11 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36842 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab3L3Q2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:28:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131217110856.GA27791@gmail.com>
References: <52af2f21.41590e0a.0251.ffffd94c@mx.google.com>
	<20131217104534.GA27383@gmail.com>
	<20131217110154.GA7602@mudshark.cambridge.arm.com>
	<20131217110856.GA27791@gmail.com>
Date: Mon, 30 Dec 2013 17:28:09 +0100
Message-ID: <CAFrcx1nh7fHzuUOz3U4C_PZGa+c4VAk80645gNPQjq5_KTOV+Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM64: add perf support
From: Jean Pihet <jean.pihet@linaro.org>
To: Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will, Ingo,

The series has been updated after the comments and re-submitted.

Thanks!
Jean

On 17 December 2013 12:08, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Will Deacon <will.deacon@arm.com> wrote:
>
>> On Tue, Dec 17, 2013 at 10:45:34AM +0000, Ingo Molnar wrote:
>> > * jean.pihet@linaro.org <jean.pihet@linaro.org> wrote:
>> > > From: Jean Pihet <jean.pihet@linaro.org>
>> > >
>> > > Add perf support for the AARCH64 architecture. This includes the
>> > > support for:
>> > > - AARCH64 perf registers definition and hooks,
>> > > - compat mode registers use, i.e. profiling a 32-bit binary on
>> > >    a 64-bit system,
>> > > - unwinding using the dwarf information from the .debug_frame
>> > >    section of the ELF binary; only in 64-bit mode,
>> > > - unwinding using the frame pointer information; in 64-bit and
>> > >    compat modes.
>> > >
>> > > ToDo:
>> > > - add support for unwinding using the dwarf information in compat
>> > >    mode. This requires some changes to the libunwind code.
>> > >
>> > > Tested on ARMv7 and ARMv8 platforms. The compat mode has been tested
>> > > on ARMv8 using statically built 32-bit binaries.
>> > >
>> > >
>> > > Jean Pihet (3):
>> > >   ARM64: perf: add support for perf registers API
>> > >   ARM64: perf: wire up perf_regs and unwind support
>> > >   ARM64: perf: add support for frame pointer unwinding in compat mode
>> > >
>> > >  arch/arm64/Kconfig                        |  2 +
>> > >  arch/arm64/include/asm/ptrace.h           |  1 +
>> > >  arch/arm64/include/uapi/asm/Kbuild        |  1 +
>> > >  arch/arm64/include/uapi/asm/perf_regs.h   | 40 ++++++++++++++
>> > >  arch/arm64/kernel/Makefile                |  1 +
>> > >  arch/arm64/kernel/perf_event.c            | 75 +++++++++++++++++++++++---
>> > >  arch/arm64/kernel/perf_regs.c             | 46 ++++++++++++++++
>> > >  tools/perf/arch/arm64/Makefile            |  7 +++
>> > >  tools/perf/arch/arm64/include/perf_regs.h | 88 +++++++++++++++++++++++++++++++
>> > >  tools/perf/arch/arm64/util/dwarf-regs.c   | 81 ++++++++++++++++++++++++++++
>> > >  tools/perf/arch/arm64/util/unwind.c       | 82 ++++++++++++++++++++++++++++
>> > >  tools/perf/config/Makefile                |  8 ++-
>> > >  12 files changed, 423 insertions(+), 9 deletions(-)
>> > >  create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
>> > >  create mode 100644 arch/arm64/kernel/perf_regs.c
>> > >  create mode 100644 tools/perf/arch/arm64/Makefile
>> > >  create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
>> > >  create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
>> > >  create mode 100644 tools/perf/arch/arm64/util/unwind.c
>> >
>> > Arnaldo, AFAICS the main merging complexity will probably be on
>> > the perf tooling side, so if you are happy with these bits, mind
>> > picking them up into your tree?
>>
>> Hold your horses! I've got a few review comments on the series...
>
> Sure :-)
>
> Thanks,
>
>         Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
