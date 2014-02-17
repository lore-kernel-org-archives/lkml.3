Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaBQPXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:23:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbaBQPXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:23:01 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 0/4] x86: Fix ftrace recovery when code modification failed
Date: Mon, 17 Feb 2014 16:22:49 +0100
Message-Id: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftrace modifies function calls using Int3 breakpoints on x86. It patches
all functions in parallel to reduce the number of sync() calls. There is
a code that removes pending Int3 breakpoints when something goes wrong.

The recovery does not work on x86_64. I simulated an error in
ftrace_replace_code() and the system got rebooted.

This patch set fixes the recovery code, improves debugging of this
type of problem, and does some clean up.

BTW: It is an echo from the patch set that tried to use text_poke_bp()
instead of the ftrace-specific Int3 based patching code. Ftrace has
some specific restrictions. I did not find a way how to make the 
universal text_poke_bp effective, safe, and clean to be usable
there.

The patch set is against linux/tip. Last commit is a5b3cca53c43c3ba7
(Merge tag 'v3.14-rc3')

Petr Mladek (4):
  x86: Clean up remove_breakpoint() in ftrace code
  x86: Fix ftrace patching recovery code to work on x86_64
  x86: BUG when ftrace patching recovery fails
  x86: Fix order of warning messages when ftrace modifies code

 arch/x86/kernel/ftrace.c | 67 ++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

-- 
1.8.4

