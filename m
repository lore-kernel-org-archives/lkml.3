Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3FZImw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:42:52 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50181 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3FZImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:42:50 -0400
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 10:42:49 +0200
Message-ID: <CABPqkBQ843gUmk596NrOyybBH63o02sz8-8qW0jOkEodrs1a7g@mail.gmail.com>
Subject: [BUG] perf report: garbage output with event grouping
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


$ perf record -e 'cpi{cycles,instructions}' noploop 5

$ perf report --stdio --group
# group: ^P^Q<A0>\{cycles,instructions}
# ========
#
# Samples: 39K of event '^P^Q<A0>\ { cycles, instructions }'
# Event count (approx.): 37782563692
#
#         Overhead  Command      Shared Object                       Symbol
# ................  .......  .................  ...........................
#
    99.91%  99.98%  noploop  noploop            [.] main
     0.06%   -nan%  noploop  [kernel.kallsyms]  [k] read_hpet
     0.01%   0.01%  noploop  [kernel.kallsyms]  [k] __acct_update_integrals
     0.01%   -nan%  noploop  [kernel.kallsyms]  [k] raise_softirq
     0.01%   -nan%  noploop  [kernel.kallsyms]  [k] apic_timer_interrupt
     0.01%   -nan%  noploop  [kernel.kallsyms]  [k] __do_softirq
     0.01%   -nan%  noploop  [kernel.kallsyms]  [k] common_interrupt
     0.00%   0.00%  noploop  [kernel.kallsyms]  [k] intel_pmu_enable_all
     0.00%   0.01%  noploop  [kernel.kallsyms]  [k] cpuacct_account_field
     0.00%   0.01%  noploop  [kernel.kallsyms]  [k] __local_bh_enable


1. The group name is garbage if not anonymous group.
2. arithmetic error in the overhead columns leading to NaN.
3. I assume the Overhead column order is the group event order. Is that right?
