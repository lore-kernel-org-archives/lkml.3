Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaAVCOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:14:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:26268 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaAVCOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:14:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="405174584"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v2 0/4] Intel MPX support 
Date: Wed, 22 Jan 2014 17:27:42 +0800
Message-Id: <1390382866-6361-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
  * check to see if #BR occurred in userspace or kernel space.
  * use generic structure and macro as much as possible when
    decode mpx instructions.

Qiaowei Ren (4):
  x86, mpx: add documentation on Intel MPX
  x86, mpx: hook #BR exception handler to allocate bound tables
  x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
  x86, mpx: extend siginfo structure to include bound violation
    information

 Documentation/x86/intel_mpx.txt    |   76 +++++++
 arch/x86/Kconfig                   |    4 +
 arch/x86/include/asm/mpx.h         |   63 ++++++
 arch/x86/include/asm/processor.h   |   16 ++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/mpx.c              |  417 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c            |   61 +++++-
 include/uapi/asm-generic/siginfo.h |    9 +-
 include/uapi/linux/prctl.h         |    6 +
 kernel/signal.c                    |    4 +
 kernel/sys.c                       |   12 +
 11 files changed, 667 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/x86/intel_mpx.txt
 create mode 100644 arch/x86/include/asm/mpx.h
 create mode 100644 arch/x86/kernel/mpx.c

