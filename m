Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaIZFum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:50:42 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47508 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaIZFuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:50:40 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Arun Sharma <asharma@fb.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf callchain: Use global caching provided by libunwind
References: <1411453828-14832-1-git-send-email-namhyung@kernel.org>
	<1411453828-14832-2-git-send-email-namhyung@kernel.org>
	<54217D09.40500@fb.com> <874mvxlprb.fsf@sejong.aot.lge.com>
	<CAFrcx1kc1FRZVosg6ziEkX-u41PiAw3=uPzKL0g87WAQnimOTg@mail.gmail.com>
Date: Fri, 26 Sep 2014 14:50:39 +0900
In-Reply-To: <CAFrcx1kc1FRZVosg6ziEkX-u41PiAw3=uPzKL0g87WAQnimOTg@mail.gmail.com>
	(Jean Pihet's message of "Wed, 24 Sep 2014 15:45:57 +0200")
Message-ID: <87bnq3j5g0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, 24 Sep 2014 15:45:57 +0200, Jean Pihet wrote:
> Hi!
>
> Here are the test results on ARMv7 for the 2 patches. The speedup is
> about x2.1 for identical unwinding output data.
>
> 'perf record --call-graph dwarf -- stress --cpu 2 --io 2 --vm 2
> --timeout 10s' generates a 365 MB perf.data file.
>
> time perf.orig report --sort symbol --call-graph --stdio 2&>1 > /dev/null
> average on 3 runs
> real    36.736
> user   14.79
> sys    21.91
>
> time perf.libunwind.speedup report --sort symbol --call-graph --stdio
> 2&>1 > /dev/null
> average on 3 runs
> real    17.41        x2.11
> user     6.42        x2.3
> sys    10.97        x2
>
> So the patches definitely speedup the unwinding.
> FWIW: Acked-by: Jean Pihet <jean.pihet@linaro.org>

Thanks for your test!

Btw, have you checked the difference of the output before and after the
caching?

>
> For info unwinding using libdw is about 5x faster:
> time perf.libdw.speedup report --sort symbol --call-graph --stdio 2&>1
>> /dev/null
> real    0m3.484s
> user    0m2.360s
> sys    0m1.070s

Wow, it's pretty nice.  I'll take a look at the libdw unwinding later.

Thanks,
Namhyung
