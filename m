Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaLACpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:45:47 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42439 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaLACpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:45:45 -0500
From: Cyril Bur <cyrilbur@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, akpm@linux-foundation.org,
        Cyril Bur <cyrilbur@gmail.com>
Subject: [PATCH 0/2] Quieten softlockup detector on virtualised kernels
Date: Mon,  1 Dec 2014 13:38:58 +1100
Message-Id: <1417401540-12121-1-git-send-email-cyrilbur@gmail.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120102-0029-0000-0000-000000B75218
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

Cyril Bur (2):
  Add another clock for use with the soft lockup watchdog.
  powerpc: add running_clock for powerpc to prevent spurious softlockup
    warnings

 arch/powerpc/kernel/time.c | 24 ++++++++++++++++++++++++
 include/linux/sched.h      |  1 +
 kernel/sched/clock.c       | 14 ++++++++++++++
 kernel/watchdog.c          |  2 +-
 4 files changed, 40 insertions(+), 1 deletion(-)

-- 
1.9.1

