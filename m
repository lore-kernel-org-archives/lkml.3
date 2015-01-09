Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbbAIDfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:35:01 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48199 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbbAIDe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:34:59 -0500
From: Cyril Bur <cyrilbur@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, drjones@redhat.com, dzickus@redhat.com,
        akpm@linux-foundation.org, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, fabf@skynet.be, atomlin@redhat.com,
        benzh@chromium.org, schwidefsky@de.ibm.com,
        Cyril Bur <cyrilbur@gmail.com>
Subject: [PATCH v2 0/2] Quieten softlockup detector on virtualised kernels
Date: Fri,  9 Jan 2015 14:34:36 +1100
Message-Id: <1420774478-16760-1-git-send-email-cyrilbur@gmail.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010903-0033-0000-0000-000000E60354
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the hypervisor pauses a virtualised kernel the kernel will observe a jump
in timebase, this can cause spurious messages from the softlockup detector.

Whilst these messages are harmless, they are accompanied with a stack trace
which causes undue concern and more problematically the stack trace in the
guest has nothing to do with the observed problem and can only be misleading.

Futhermore, on POWER8 this is completely avoidable with the introduction of
the Virtual Time Base (VTB) register.

V2:
	Remove the export of running_clock
	Added #ifdef CONFIG_PPC_PSERIES and optimised the non lpar + vtb cases.
	Replaced the use of sched_clock_with local_clock it was used originally in
the softlockup detector.

Cyril Bur (2):
  Add another clock for use with the soft lockup watchdog.
  powerpc: add running_clock for powerpc to prevent spurious softlockup
    warnings

 arch/powerpc/kernel/time.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/sched.h      |  1 +
 kernel/sched/clock.c       | 13 +++++++++++++
 kernel/watchdog.c          |  2 +-
 4 files changed, 47 insertions(+), 1 deletion(-)

-- 
1.9.1

