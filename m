Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab3KOLlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:41:19 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60521 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3KOLlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:41:02 -0500
MIME-Version: 1.0
Date: Fri, 15 Nov 2013 12:41:00 +0100
Message-ID: <CABPqkBRq7-ubdjk_3jXHXYDHOH_zSg+Grob7QnzLk3f43+9wUQ@mail.gmail.com>
Subject: [BUG] perf report: bogus event group name reported
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Testing event group in sampling mode and finding
issues on the reporting side:

$ perf record --group -e 'grp1{cycles,instructions}' noploop 1
$ perf report --group  --stdio
...
# group: M^B{cycles,instructions}
             ^^^^ broken group name

# ========
#
# Samples: 8K of event '[binfmt_misc] { cycles, instructions }'
                                   ^^^^^^^^^^^^^^ broken event group name

# Event count (approx.): 7024115127
#
#         Overhead  Command      Shared Object                       Symbol
# ................  .......  .................  ...........................
#
    99.96%  99.97%  noploop  noploop            [.] main
     0.03%   0.03%  noploop  [kernel.kallsyms]  [k] apic_timer_interrupt
     0.01%   0.01%  noploop  [kernel.kallsyms]  [k] find_get_page
