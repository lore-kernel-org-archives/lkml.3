Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaGII03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:26:29 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58638 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGII01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:26:27 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, acme@redhat.com
Subject: Re: [PATCH v1 0/4] perf: add ability to sample interrupted machine state
References: <1404857759-25105-1-git-send-email-eranian@google.com>
Date: Wed, 09 Jul 2014 17:26:20 +0900
In-Reply-To: <1404857759-25105-1-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Wed, 9 Jul 2014 00:15:55 +0200")
Message-ID: <87mwcj2b0z.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Wed,  9 Jul 2014 00:15:55 +0200, Stephane Eranian wrote:
> This short patch series add the ability to sample the interrupted
> machine state for each hardware sample. This is useful to analyze
> the state after certain events, for instance for function value
> profiling after a call instruction.
>
> The patch extends the interface with a new PERF_SAMPLE_REGS_INTR 
> smaple_type flag. The register to sample can be named in the
> sample_regs_intr bitmask for each event. The name and bit
> position for each register is architecture dependent and
> provided, just like for PERF_SAMPLE_REGS_USER by asm/perf_regs.h.
>
> The support is similar to PERF_SAMPLE_REGS_USER.
>
> On Intel x86, the series includes support for capturing the
> PEBS state as well. When precise sampling is used, the interrupted
> state is collect from the PEBS records, at least partially.
> The PEBS machine state is a subset of the machine state.
>
> The series provides access to this new feature in perf record
> with the -I option. It is possible to display the sampled
> register values using perf report -D.
>
> This patch series is the fundation for a future series adding
> function value profiling.

Probably a silly question: what is the function value profiling?

Anyway, I'll try to review it tomorrow. :)

Thanks,
Namhyung


>
> Stephane Eranian (4):
>   perf: add ability to sample machine state on interrupt
>   perf/x86: add support for sampling PEBS machine state registers
>   perf tools: add core support for sampling intr machine state regs
>   perf record: add new -I option to sample interrupted machine state
>
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |   19 +++++++++++++
>  include/linux/perf_event.h                |    7 +++--
>  include/uapi/linux/perf_event.h           |   14 ++++++++-
>  kernel/events/core.c                      |   44 +++++++++++++++++++++++++++--
>  tools/perf/builtin-record.c               |    2 ++
>  tools/perf/perf.h                         |    1 +
>  tools/perf/util/event.h                   |    7 +++++
>  tools/perf/util/evsel.c                   |   23 ++++++++++++++-
>  tools/perf/util/session.c                 |   26 +++++++++++++++++
>  9 files changed, 137 insertions(+), 6 deletions(-)
