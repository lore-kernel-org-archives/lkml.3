Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaBXQMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:12:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbaBXQM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:12:28 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v2 0/3] ftrace/x86: Recovery code fixes and improvements
Date: Mon, 24 Feb 2014 17:12:19 +0100
Message-Id: <1393258342-29978-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is folowup from the discussion (Re: [PATCH 0/4] x86: Fix ftrace recovery
when code modification failed), see https://lkml.org/lkml/2014/2/21/748

I split the fixes into three patches:

1st patch adds the missing sync call. I guess that Steven would want to
squash this into the commit f06492158f4b0cdb (ftrace/x86: Run a sync
after fixup on failure) in the ftrace/urgent branch.

2nd patch adds the missing warnigns about ftrace modification failure
into the generic code as suggested by Steven[*]. I used "err" instead
of the suggested "ret" variable. The value is handled but it is not
returned. Also I left ftrace_replace_code() calls as is. It handles
the error, prints more details, and does not return the error value.

3rd patch adds the BUG calls. Steven did not comment on it, so I rather
put this into a separate patch, so it does not block the other things.

[*] I feel shame that I was not brave enough to do modify the generic code
when I sent the patch on Friday.

Petr Mladek (3):
  ftrace/x86: One more missing sync after fixup of function modification
    failure
  ftrace: Warn on error when modifying ftrace function
  ftrace/x86: BUG when ftrace recovery fails

 arch/x86/kernel/ftrace.c | 24 ++++++++++++++++--------
 kernel/trace/ftrace.c    | 17 ++++++++++++-----
 2 files changed, 28 insertions(+), 13 deletions(-)

-- 
1.8.4

