Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbbAVExd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:53:33 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62702 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbAVExY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:53:24 -0500
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: [PATCH V2 0/3] perf symbols: debuglink and arm mapping symbols changes
Date: Wed, 21 Jan 2015 20:52:55 -0800
Message-Id: <1421902378-3634-1-git-send-email-victor.kamensky@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

Here is second version of mini-series that addresses couple issues
in perf symbols handling.

Changes since V1:

o 'perf symbols: Ignore mapping symbols on aarch64': based on feedback
from Will Deacon and Russell King [1] added code that handles ARM/Aarch64
mapping symbols like "$d.<any>". Code uses similar snipet to handle
ARM mapping symbols as in another places in kernel, but it has its
own version of the code. Added proper Acked-by.

o 'perf symbols: debuglink should take symfs option into account':
based on feedback from David Ahern [2] picked more simple version that
does not make malloced copy of 'filename', that makes patch simpler.
Added proper 'Acked-and-tested-by'.

[1] https://lkml.org/lkml/2015/1/13/507

[2] https://lkml.org/lkml/2015/1/13/508

Victor Kamensky (3):
  perf symbols: Ignore mapping symbols on aarch64
  perf symbols: improve abi compliance in arm mapping symbols handling
  perf symbols: debuglink should take symfs option into account

 tools/perf/util/dso.c        |  6 +++---
 tools/perf/util/symbol-elf.c | 13 ++++++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

-- 
1.9.3

