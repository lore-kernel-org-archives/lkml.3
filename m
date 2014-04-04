Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaDDUrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:47:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaDDUrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:47:20 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/4 V2] Print traces on softlockups
Date: Fri,  4 Apr 2014 16:47:06 -0400
Message-Id: <1396644430-70649-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 of this patchset.

Added more patches to handle the 'uniprocessor' panic case by sending NMIs
to every cpu but self.  Only affects x86, sparc.

Aaron Tomlin (4):
  nmi: Provide the option to issue an NMI back trace to every cpu but
    current
  x86, nmi: Add more flexible NMI back trace support
  sparc64, nmi: Add more flexible NMI back trace support
  watchdog: Printing traces for all cpus on lockup detection

 Documentation/kernel-parameters.txt |    5 +++++
 Documentation/sysctl/kernel.txt     |   17 +++++++++++++++++
 arch/sparc/include/asm/irq_64.h     |    2 +-
 arch/sparc/kernel/process_64.c      |   14 +++++++++-----
 arch/x86/include/asm/irq.h          |    2 +-
 arch/x86/kernel/apic/hw_nmi.c       |   16 +++++++++++++---
 include/linux/nmi.h                 |   12 +++++++++++-
 kernel/sysctl.c                     |    9 +++++++++
 kernel/watchdog.c                   |   32 ++++++++++++++++++++++++++++++++
 9 files changed, 98 insertions(+), 11 deletions(-)

