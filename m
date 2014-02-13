Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaBMB3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:29:00 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45566 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaBMB24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:28:56 -0500
X-AuditID: 85900ec0-d0927b9000001514-09-52fc1fd5a1f4
Subject: [PATCH -tip RESEND 0/2] ftrace: Introduce the new I/F
 "nr_saved_cmdlines"
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Thu, 13 Feb 2014 10:28:52 +0900
Message-ID: <20140213012852.15283.50473.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This patch set introduces the new I/F "nr_saved_cmdlines" for increasing
the number of saved cmdlines. Current saved_cmdlines can store just 128 command 
names and PIDs, but process names are often lost like <...> when we read trace
data. If the process exists, we can get the name by using ps command. However,
if the process already has not existed, we cannot get the name.

To solve this issue, we introduce the new I/F "nr_saved_cmdlines" to expand
the max number of saved command line names. This I/F is very simple.
If we write a number to nr_saved_cmdlines, the number of command name will be
stored. And, if we read the I/F, we can get current maximum number of command
name. The default number is 128 which is current default number, so this patch
does not change the usage of memory for saved_cmdlines when we boot kernel.

Thanks!

Note: This patch set was rebased for current tip ftrace-core kernel.

---

Yoshihiro YUNOMAE (2):
      ftrace: Make saved_cmdlines use seq_read
      ftrace: Introduce nr_saved_cmdlines I/F


 kernel/trace/trace.c |  296 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 241 insertions(+), 55 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
