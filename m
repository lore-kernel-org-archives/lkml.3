Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbaEGPgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:36:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbaEGPfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:35:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/5 RESEND] x86, nmi: Various fixes and cleanups
Date: Wed,  7 May 2014 11:34:38 -0400
Message-Id: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started this patch by fixing a performance problem with the GHES
NMI handler and then things evolved to more patches as I was poking
around in the code.

The main focus was moving the GHES NMI driver to its own NMI subtype
to avoid slowing down perf handling.  Then I decided to move the
default external NMI handler to its own routine.  Then finally, I
needed to see which NMI handlers were registered so I hacked up
/proc/interrupts to show me.

Tested mostly on HP boxes that have GHES enabled and having the iLO
send NMIs to panic the box (using hpwdt driver).  Ran perf on other
GHES enabled boxes to test performance results.

Update: I realized I didn't send this to lkml initially.  Might be why no one
has commented on it more.

Don Zickus (5):
  x86, nmi:  Add new nmi type 'external'
  x86, nmi: Add boot line option 'panic_on_unrecovered_nmi' and
    'panic_on_io_nmi'
  x86, nmi: Remove 'reason' value from unknown nmi output
  x86, nmi: Move default external NMI handler to its own routine
  x86, nmi: Add better NMI stats to /proc/interrupts and show handlers

 Documentation/kernel-parameters.txt |    9 ++
 arch/x86/include/asm/nmi.h          |    5 +
 arch/x86/kernel/irq.c               |    3 +
 arch/x86/kernel/nmi.c               |  199 ++++++++++++++++++++++++++--------
 drivers/acpi/apei/ghes.c            |    4 +-
 drivers/watchdog/hpwdt.c            |   24 +++--
 6 files changed, 187 insertions(+), 57 deletions(-)

