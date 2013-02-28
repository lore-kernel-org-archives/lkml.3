Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3B1LA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:00:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab3B1LAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:00:54 -0500
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC PATCH v3 0/6] uprobes: return probe implementation
Date: Thu, 28 Feb 2013 12:00:09 +0100
Message-Id: <1362049215-5780-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

  RFC v3 uretprobes implementation. I'd be grateful for review.

  These patches extending uprobes by enabling tools, such as perf(trace_event),
set a breakpoint on probed function's return address. 

v3 changes:
  - removed uretprobe_bypass logic, it will be better to send it as
    independent patch
  - unified xol_get_trampoline_slot() and xol_get_insn_slot()
  - protected uprobe with refcounter in prepare_uretprobe()
  - uprobe_register() routine fails now, if neither consumer is set
  - enclosed implementation into 1/6, 6/6 patches -ENOSYS bits

v2 changes:
  - introduced rp_handler(), get rid of return_consumers
  - get rid of uretprobe_[un]register()
  - introduced arch_uretprobe_get_sp()
  - removed uprobe_task->doomed, kill task immediately
  - fix arch_uretprobe_hijack_return_addr()'s returns
  - address the v1 minor issues

integrated patchset:
  http://github.com/arapov/linux-aa/commits/uretprobes_v3

previous implementations:
  RFCv2: https://lkml.org/lkml/2013/1/9/157
  RFCv1: https://lkml.org/lkml/2012/12/21/133

thanks,
Anton

Anton Arapov (6):
  uretprobes: preparation patch
  uretprobes/x86: hijack return address
  uretprobes: generalize xol_get_insn_slot()
  uretprobes: return probe entry, prepare uretprobe
  uretprobes: invoke return probe handlers
  uretprobes: implemented, thus remove -ENOSYS

 arch/x86/include/asm/uprobes.h |   6 +++
 arch/x86/kernel/uprobes.c      |  29 +++++++++++
 include/linux/uprobes.h        |   6 +++
 kernel/events/uprobes.c        | 112 ++++++++++++++++++++++++++++++++++++++---
 4 files changed, 146 insertions(+), 7 deletions(-)

-- 
1.8.1.2
