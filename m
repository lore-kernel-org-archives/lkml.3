Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaAQIIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:08:48 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42209 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaAQIIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:08:46 -0500
X-AuditID: 9c930197-b7b7cae000000e34-ff-52d8e50a0aba
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCHSET 0/5] tracing/uprobes: Support multi buffer and event trigger
Date: Fri, 17 Jan 2014 17:08:35 +0900
Message-Id: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
(Resending with LKML CC'ed)

This patchset tries to add support for recent multi buffer and event
trigger changes to uprobes.  The multi buffer support patch is an
updated version of Zovi's previous patch v6 [1].

Zovi, please tell me if you have any update and/or issues with this.

Masami and Oleg, I kept your Reviewed-by's in the patch since I think
it's just an rebase.  Please take a look again to see whether I added
some mistakes.


You can also get it from 'uprobe/trigger-v1' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


[1] https://lkml.org/lkml/2013/7/4/165

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>                          


Namhyung Kim (4):
  tracing/uprobes: Rename uprobe_{trace,perf}_print() functions
  tracing/uprobes: Move argument fetching to uprobe_dispatcher()
  tracing/uprobes: Support event triggering
  tracing/uprobes: Support mix of ftrace and perf

zhangwei(Jovi) (1):
  tracing/uprobes: Support ftrace_event_file base multibuffer

 kernel/trace/trace_kprobe.c |  17 ----
 kernel/trace/trace_probe.h  |  17 ++++
 kernel/trace/trace_uprobe.c | 191 +++++++++++++++++++++++++++++++-------------
 3 files changed, 151 insertions(+), 74 deletions(-)

-- 
1.7.11.7

