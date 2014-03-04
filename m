Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaCDKit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:38:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230AbaCDKir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:38:47 -0500
Date: Tue, 4 Mar 2014 11:37:59 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 0/3] perf tools: Add libdw DWARF post unwind support for
 ARM
Message-ID: <20140304103759.GB1119@krava.brq.redhat.com>
References: <1393840403-26639-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1mg03A+e7q2d1HR=bR7uoDw5k36TVw5TQP68caWYBNJnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1mg03A+e7q2d1HR=bR7uoDw5k36TVw5TQP68caWYBNJnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 02:24:37AM +0100, Jean Pihet wrote:
> Hi,
> 
> Here are some notes about the performance improvement and the test usage.
> 
> Jiri, do you need these notes in the one of commit description?
> 
> 1. Using libdw vs libunwind on ARMv7
> 
> The performance gain is (more than) significant: >800%.

I dont mind.. but 800% would look just great in changelog ;-)

jirka

> 
> I did not profile perf itself ;-p just did a timing measurement.
> The benchmark has been run multiple times with different perf.data
> sizes. The results are consistent across the tests runs.
> 
> Usage:
> ./tools/perf/perf record --call-graph dwarf --
> ../../libunwind/test_app/stress_bt
> time ./tools/perf/perf report --stdio > /dev/null 2>&1
> 
> Platform:
> Quad-core marvell XP370. perf runs on 1 cpu
> 
> Perf data size:
> 304MB    libunwind    libdw        improvement
> real    9m31.577s    1m13.052s    782%
> user    5m33.020s    1m2.910s    529%
> sys        3m57.770s    0m10.090s    2356%
> 
> 2. unwind test usage
> perf test list gives the list of supported tests. In this case the
> test #23 is dwarf unwinding:
> 
> ./tools/perf/perf test 23
> 23: Test dwarf unwind                                      : Ok
> 
> 
> Regards,
> Jean
> 
> 
> On 3 March 2014 10:53, Jean Pihet <jean.pihet@linaro.org> wrote:
> > Adding libdw DWARF post unwind support, which is part
> > of elfutils-devel/libdw-dev package from version 0.158.
> >
> > Also includes the test suite for dwarf unwinding, by adding the
> > arch specific test code and the perf_regs_load function.
> >
> > Jean Pihet (3):
> >   perf tests: Introduce perf_regs_load function on ARM
> >   perf tests: Add dwarf unwind test on ARM
> >   perf tools: Add libdw DWARF post unwind support for ARM
> >
> >  tools/perf/Makefile.perf                 |  2 +-
> >  tools/perf/arch/arm/Makefile             |  7 ++++
> >  tools/perf/arch/arm/include/perf_regs.h  |  5 +++
> >  tools/perf/arch/arm/tests/dwarf-unwind.c | 59 ++++++++++++++++++++++++++++++++
> >  tools/perf/arch/arm/tests/regs_load.S    | 51 +++++++++++++++++++++++++++
> >  tools/perf/arch/arm/util/unwind-libdw.c  | 36 +++++++++++++++++++
> >  tools/perf/tests/builtin-test.c          |  2 +-
> >  tools/perf/tests/tests.h                 |  2 +-
> >  8 files changed, 161 insertions(+), 3 deletions(-)
> >  create mode 100644 tools/perf/arch/arm/tests/dwarf-unwind.c
> >  create mode 100644 tools/perf/arch/arm/tests/regs_load.S
> >  create mode 100644 tools/perf/arch/arm/util/unwind-libdw.c
> >
> > ---
> >
> > - Rebased on latest acme/perf/core git tree,
> > - Tested on quad-core ARMv7 machine
> >
> > --
> > 1.7.11.7
> >
