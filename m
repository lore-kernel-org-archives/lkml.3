Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbaCDL6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:58:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757AbaCDL6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:58:52 -0500
Date: Tue, 4 Mar 2014 12:58:18 +0100
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
Message-ID: <20140304115756.GC1119@krava.brq.redhat.com>
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

I can't speak for the arm specific stuff, but generally it fits
and looks ok (and does not break the x86 build)

also.. who wouldn't ack 800% speed improvement ;-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
