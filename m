Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3GRLu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:50:29 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52516 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3GRLu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:50:28 -0400
X-AuditID: 85900ec0-d56cbb900000151e-01-51e7d681cebf
Subject: [PATCH -tip  0/3] kprobes,
 x86: Move optprobe on top of int3-based instruction patching
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Date: Thu, 18 Jul 2013 20:47:38 +0900
Message-ID: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a series of kprobes and x86 patches for moving
optprobe (jump optimized kprobe) onto the int3-based
instruction patching (a.k.a. text_poke_bp, introduced by
Jiri Kosina).

Since this completely moves text_poke_smp* user to new
text_poke_bp, I also remove the old text_poke_smp* code
from alternative.c. As a side effect, it also fixes a
Kconfig warning about CONFIG_STOP_MACHINE dependency
confliction.

Thank you,

---

Masami Hiramatsu (3):
      [CLEANUP] kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
      kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
      x86: Remove unused text_poke_smp and text_poke_smp_batch


 arch/x86/Kconfig                   |    5 --
 arch/x86/include/asm/alternative.h |   11 ----
 arch/x86/kernel/alternative.c      |   98 +-------------------------------
 arch/x86/kernel/kprobes/common.h   |    5 --
 arch/x86/kernel/kprobes/core.c     |    2 -
 arch/x86/kernel/kprobes/opt.c      |  110 +++++++-----------------------------
 6 files changed, 25 insertions(+), 206 deletions(-)

-- 
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
IT Management Research Dept. and Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
