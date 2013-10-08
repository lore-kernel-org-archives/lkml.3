Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3JHHq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:46:57 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:39174 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3JHHqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:46:54 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mundt <paul.mundt@gmail.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 0/3]  Move ARCH specific fpu_counter out of task_struct
Date: Tue, 8 Oct 2013 13:16:26 +0530
Message-ID: <1381218389-16585-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When debugging a ARC SMP 3.11 build failure due to a ST insn dealing with
task_struct.thread going out of range, I spotted @fpu_counter in task_struct
which only SH/x86 happen to use, and can be easily moved out into corresponding
ARCH specific thread_struct. This saves 4 bytes per task_struct instantiated,
for all the other 18 arches.

While the change is relatively strightforward, I've failed to connect with
SH arch folks / Paul Mundt, latter's SH email keeps bouncing back.
Hence I'm taking the liberty to use his alternate email (as listed on his
github page) and I appologize in advance if this causes any inconvenience.

Changes in v2:
- Rabased to 3.12-rc4
- Added ACK from Ingo on patch 2/3

Version 1 can be found here:
https://lkml.org/lkml/2013/9/17/49

Thx,
-Vineet


Vineet Gupta (3):
  sh: Move fpu_counter into ARCH specific thread_struct
  x86: Move fpu_counter into ARCH specific thread_struct
  sched: Remove ARCH specific fpu_counter from task_struct

 arch/sh/include/asm/fpu.h           |  2 +-
 arch/sh/include/asm/processor_32.h  | 10 ++++++++++
 arch/sh/include/asm/processor_64.h  | 10 ++++++++++
 arch/sh/kernel/cpu/fpu.c            |  2 +-
 arch/sh/kernel/process_32.c         |  6 +++---
 arch/x86/include/asm/fpu-internal.h | 10 +++++-----
 arch/x86/include/asm/processor.h    |  9 +++++++++
 arch/x86/kernel/i387.c              |  2 +-
 arch/x86/kernel/process_32.c        |  4 ++--
 arch/x86/kernel/process_64.c        |  2 +-
 arch/x86/kernel/traps.c             |  2 +-
 include/linux/sched.h               |  9 ---------
 12 files changed, 44 insertions(+), 24 deletions(-)

-- 
1.8.1.2

