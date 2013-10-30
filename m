Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3J3Kxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:53:43 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44526 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3J3Kxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:53:42 -0400
X-AuditID: 85900ec0-d1328b9000001514-8a-5270e5338a47
Subject: [PATCH -tip  0/2] kprobes: fix bugs by updating blacklist
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: x86@kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Wed, 30 Oct 2013 10:53:34 +0000
Message-ID: <20131030105334.7997.750.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I've found that putting probes on some functions
could lock or reboot the kernel. These two patches fix
those bugs by prohibiting probing such functions by
adding those to blacklist(kprobes.text).

In both cases, those functions are related to int3 handling
execution path. One is related to irqoff-tracer and the other
is related to notifier debug option.

Thank you,

---

Masami Hiramatsu (2):
      [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
      [BUGFIX] kprobes: Prohibit probing on func_ptr_is_kernel_text


 arch/x86/kernel/cpu/common.c |    7 ++++---
 kernel/extable.c             |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
