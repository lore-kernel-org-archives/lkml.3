Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3DVJmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:42:11 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:41344 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3DVJmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:42:07 -0400
X-AuditID: 85900ec0-d2ec7b900000151e-78-517505614278
Subject: [PATCH V2 0/3] trace-cmd: Support a raw format for outputting
 timestamp
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 22 Apr 2013 18:43:07 +0900
Message-ID: <20130422094306.26615.70754.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This patch series extracts the trace_clock file for switching outputting format 
of timestamp. This patch series uses the options feature, so trace-cmd keeps
backward compatibility.

In tsc or counter modes, trace-cmd should output timestamp not in the sec.usec
format but in the raw format. For example, we will show results in trace-cmd
report mode as follows by applying this patch series:

<for local or global mode>
            bash-9022  [000] 34984.109846: sched_wakeup:         comm=migration/3 pid=23 prio=0 success=1 target_cpu=003
          <idle>-0     [002] 34984.109847: cpu_idle:             state=4294967295 cpu_id=2
            bash-9022  [000] 34984.109848: sched_switch:         prev_comm=bash prev_pid=9022 prev_prio=120 prev_state=R ==> next_comm=migration/0 next_pid=8 next_prio=0
          <idle>-0     [002] 34984.109849: sched_switch:         prev_comm=swapper/2 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=migration/2 next_pid=18 next_prio=0

<for tsc or counter mode>
            bash-9022  [000] 34984109846: sched_wakeup:         comm=migration/3 pid=23 prio=0 success=1 target_cpu=003
          <idle>-0     [002] 34984109847: cpu_idle:             state=4294967295 cpu_id=2
            bash-9022  [000] 34984109848: sched_switch:         prev_comm=bash prev_pid=9022 prev_prio=120 prev_state=R ==> next_comm=migration/0 next_pid=8 next_prio=0
          <idle>-0     [002] 34984109849: sched_switch:         prev_comm=swapper/2 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=migration/2 next_pid=18 next_prio=0

v2:
 - Separate input/output patches (2/3 and 3/3)
 - Define TRACECMD_OPTION_TRACECLOCK for extracting trace_clock (2/3)
 - Check whether TRACECMD_OPTION_TRACECLOCK exists or not in trace.dat (3/3)

Thank you,

---

Yoshihiro YUNOMAE (3):
      trace-cmd: Define general functions for outputting/inputting saved_cmdlines
      trace-cmd: Add recording to trace_clock
      trace-cmd: Add support for extracting trace_clock in report


 event-parse.c  |   50 ++++++++++++++++++++++++++++-------
 event-parse.h  |    6 ++++
 trace-cmd.h    |    3 ++
 trace-input.c  |   79 ++++++++++++++++++++++++++++++++++++++++++++++----------
 trace-output.c |   65 +++++++++++++++++++++++++++-------------------
 trace-read.c   |    4 ++-
 trace-record.c |    3 ++
 trace-util.c   |   26 ++++++++++++++++++
 8 files changed, 182 insertions(+), 54 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
