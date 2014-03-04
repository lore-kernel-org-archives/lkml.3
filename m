Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaCDBY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:24:57 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57619 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbaCDBYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <1393840403-26639-1-git-send-email-jean.pihet@linaro.org>
References: <1393840403-26639-1-git-send-email-jean.pihet@linaro.org>
Date: Tue, 4 Mar 2014 02:24:37 +0100
Message-ID: <CAFrcx1mg03A+e7q2d1HR=bR7uoDw5k36TVw5TQP68caWYBNJnQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf tools: Add libdw DWARF post unwind support for ARM
From: Jean Pihet <jean.pihet@linaro.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Steve Capper <steve.capper@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some notes about the performance improvement and the test usage.

Jiri, do you need these notes in the one of commit description?

1. Using libdw vs libunwind on ARMv7

The performance gain is (more than) significant: >800%.

I did not profile perf itself ;-p just did a timing measurement.
The benchmark has been run multiple times with different perf.data
sizes. The results are consistent across the tests runs.

Usage:
./tools/perf/perf record --call-graph dwarf --
../../libunwind/test_app/stress_bt
time ./tools/perf/perf report --stdio > /dev/null 2>&1

Platform:
Quad-core marvell XP370. perf runs on 1 cpu

Perf data size:
304MB    libunwind    libdw        improvement
real    9m31.577s    1m13.052s    782%
user    5m33.020s    1m2.910s    529%
sys        3m57.770s    0m10.090s    2356%

2. unwind test usage
perf test list gives the list of supported tests. In this case the
test #23 is dwarf unwinding:

./tools/perf/perf test 23
23: Test dwarf unwind                                      : Ok


Regards,
Jean


On 3 March 2014 10:53, Jean Pihet <jean.pihet@linaro.org> wrote:
> Adding libdw DWARF post unwind support, which is part
> of elfutils-devel/libdw-dev package from version 0.158.
>
> Also includes the test suite for dwarf unwinding, by adding the
> arch specific test code and the perf_regs_load function.
>
> Jean Pihet (3):
>   perf tests: Introduce perf_regs_load function on ARM
>   perf tests: Add dwarf unwind test on ARM
>   perf tools: Add libdw DWARF post unwind support for ARM
>
>  tools/perf/Makefile.perf                 |  2 +-
>  tools/perf/arch/arm/Makefile             |  7 ++++
>  tools/perf/arch/arm/include/perf_regs.h  |  5 +++
>  tools/perf/arch/arm/tests/dwarf-unwind.c | 59 ++++++++++++++++++++++++++++++++
>  tools/perf/arch/arm/tests/regs_load.S    | 51 +++++++++++++++++++++++++++
>  tools/perf/arch/arm/util/unwind-libdw.c  | 36 +++++++++++++++++++
>  tools/perf/tests/builtin-test.c          |  2 +-
>  tools/perf/tests/tests.h                 |  2 +-
>  8 files changed, 161 insertions(+), 3 deletions(-)
>  create mode 100644 tools/perf/arch/arm/tests/dwarf-unwind.c
>  create mode 100644 tools/perf/arch/arm/tests/regs_load.S
>  create mode 100644 tools/perf/arch/arm/util/unwind-libdw.c
>
> ---
>
> - Rebased on latest acme/perf/core git tree,
> - Tested on quad-core ARMv7 machine
>
> --
> 1.7.11.7
>
