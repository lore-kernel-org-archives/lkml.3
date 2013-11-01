Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3KALZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:25:36 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33591 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KALZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:25:35 -0400
Subject: [PATCH -tip v2 0/3] kprobes: introduce nokprobe and updating
 blacklist
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: x86@kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Fri, 01 Nov 2013 11:25:30 +0000
Message-ID: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Ingo's suggestion, I've introduced 'nokprobe'
new annotation as like as 'notrace' annotation, since
__kprobes annotation is too confusing to mark non-kprobe
able functions.
I took 'nokprobe' instead of 'noprobe' since we already
have irq_set_noprobe() etc.

Also, I've found that putting probes on some functions
could lock or reboot the kernel. These two patches fix
those bugs by prohibiting probing such functions by
adding those to blacklist(kprobes.text).

In both cases, those functions are related to int3 handling
execution path. One is related to irqoff-tracer and the other
is related to notifier debug option.

Thank you,

 Changes in the latest version:
  - introduce nokprobe annotation
  - change __kprobes to nokprobe in bugfixes
  - remove unneeded linux/kprobes.h includings.

---

Masami Hiramatsu (3):
      kprobes: Introduce nokprobe annotation for non-probe-able functions
      [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
      [BUGFIX] kprobes: Prohibit probing on func_ptr_is_kernel_text


 arch/x86/kernel/cpu/common.c |    6 +++---
 include/linux/compiler.h     |    6 ++++--
 kernel/extable.c             |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

