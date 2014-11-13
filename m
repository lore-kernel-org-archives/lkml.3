Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511AbaKMWb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:31:26 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39650 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbaKMWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:31:25 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/2] Handle IST interrupts from userspace on the normal stack
Date: Thu, 13 Nov 2014 14:31:19 -0800
Message-Id: <cover.1415917623.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently run IST interrupt handlers on the IST stack.  Changing
it may simplify a few things.  See patch 2 for details.

Patch 1 is a fix for a not-quite-bug in uprobes that Oleg noticed
that would be exposed by patch 2.

Andy Lutomirski (2):
  x86, entry: Switch stacks on a paranoid entry from userspace
  uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME

 Documentation/x86/entry_64.txt         | 18 +++++---
 Documentation/x86/x86_64/kernel-stacks |  8 ++--
 arch/x86/include/asm/thread_info.h     |  2 +-
 arch/x86/kernel/entry_64.S             | 82 +++++++++++++++++-----------------
 arch/x86/kernel/traps.c                | 23 +++-------
 kernel/events/uprobes.c                |  1 -
 6 files changed, 65 insertions(+), 69 deletions(-)

-- 
1.9.3

