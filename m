Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161185Ab3DEBxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:53:51 -0400
Received: from fallback.hitachi.co.jp ([133.145.228.50]:43318 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161131Ab3DEBxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:53:46 -0400
X-AuditID: 85900ec0-d38c8b900000151e-73-515e2e198a61
Subject: [PATCH 0/2] trace-cmd: Support a raw format for outputting timestamp
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Fri, 05 Apr 2013 10:54:39 +0900
Message-ID: <20130405015439.19807.43932.stgit@yunodevel>
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
of timestamp because in tsc or counter modes, trace-cmd should output timestamp
not in the sec.usec format but in the raw format.

For example, we will show results in trace-cmd report mode as follows by
applying this patch series:

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

Would you apply this patch series for trace-cmd?

Thank you,

---

Yoshihiro YUNOMAE (2):
      trace-cmd: Define general functions for outputting/inputting saved_cmdlines
      trace-cmd: Support trace_clock extraction


 event-parse.c  |   44 ++++++++++++++++++++++++++++--------
 event-parse.h  |    3 ++
 trace-cmd.h    |    1 +
 trace-input.c  |   61 ++++++++++++++++++++++++++++++++++++++++----------
 trace-output.c |   68 ++++++++++++++++++++++++++++++++++----------------------
 trace-util.c   |   26 +++++++++++++++++++++
 6 files changed, 153 insertions(+), 50 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
