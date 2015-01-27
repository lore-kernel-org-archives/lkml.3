Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbbA0GeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:34:18 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61956 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbbA0GeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:34:16 -0500
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: [PATCH V3 0/2] perf symbols: debuglink and arm mapping symbols changes
Date: Mon, 26 Jan 2015 22:34:00 -0800
Message-Id: <1422340442-4673-1-git-send-email-victor.kamensky@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

Here is third version of mini-series that addresses couple issues
in perf symbols handling.

Changes since V2:

o Since V2 caused some controversy wrt aarch64/arm fixes [3], replace
'perf symbols: Ignore mapping symbols on aarch64' and 'perf symbols: 
improve abi compliance in arm mapping symbols handling with another 
version of almost equivalent single patch that was discussed on [1].
In new patch superset of aarch64 and arm mapping symbols handled by
single code snippet, that is more aligned with other places where
aarch64 and arm mapping symbols are handled.

Changes since V1:

o 'perf symbols: Ignore mapping symbols on aarch64': based on feedback
from Will Deacon and Russell King [1] added code that handles ARM/Aarch64
mapping symbols like "$d.<any>". Code uses similar snippet to handle
ARM mapping symbols as in another places in kernel, but it has its
own version of the code. Added proper Acked-by.

o 'perf symbols: debuglink should take symfs option into account':
based on feedback from David Ahern [2] picked more simple version that
does not make malloced copy of 'filename', that makes patch simpler.
Added proper 'Acked-and-tested-by'.

[1] https://lkml.org/lkml/2015/1/13/507

[2] https://lkml.org/lkml/2015/1/13/508

[3] https://lkml.org/lkml/2015/1/22/382

Victor Kamensky (2):
  perf symbols: Ignore mapping symbols on aarch64
  perf symbols: debuglink should take symfs option into account

 tools/perf/util/dso.c        | 6 +++---
 tools/perf/util/symbol-elf.c | 7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

-- 
1.9.3

