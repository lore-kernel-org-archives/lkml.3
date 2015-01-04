Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbbADSg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 13:36:29 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33268 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbbADSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 13:36:28 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>, root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: [PATCH 0/2] perf: Improve user regs sampling
Date: Sun,  4 Jan 2015 10:36:18 -0800
Message-Id: <cover.1420396372.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20150104174105.GA29388@krava.brq.redhat.com>
References: <20150104174105.GA29388@krava.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to improve the situation on x86_64 from almost entirely
broken to mostly working.  Tested with:

perf record -e cycles --call-graph=dwarf ls

Andy Lutomirski (2):
  perf: Move task_pt_regs sampling into arch code
  x86_64, perf: Improve user regs sampling

 arch/arm/kernel/perf_regs.c   |  8 ++++
 arch/arm64/kernel/perf_regs.c |  8 ++++
 arch/x86/kernel/perf_regs.c   | 90 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h    | 12 +++---
 include/linux/perf_regs.h     | 16 ++++++++
 kernel/events/core.c          | 19 ++++-----
 6 files changed, 137 insertions(+), 16 deletions(-)

-- 
2.1.0

