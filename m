Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3A3AYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:24:15 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47234
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3A3AYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:24:12 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com, bp@alien8.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] X86: Deliver Hyper-V interrupts on a seperate IDT vector
Date: Tue, 29 Jan 2013 16:51:17 -0800
Message-Id: <1359507077-26050-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set implements the functionality to deliver Hyper-V VMBUS interrupts via
a special IDT entry. Xen emulates Hyper-V and we have added code in this patch-set to
properly manage this emulation when Linux is running on Hyper-V.

K. Y. Srinivasan (2):
  X86: Add a check to catch Xen emulation of Hyper-V
  X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts

Olaf Hering (1):
  x86: Hyper-V: register clocksource only if its advertised

 arch/x86/include/asm/irq_vectors.h |    4 +-
 arch/x86/include/asm/mshyperv.h    |    4 +++
 arch/x86/kernel/cpu/mshyperv.c     |   48 +++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/entry_32.S         |    9 ++++++-
 arch/x86/kernel/entry_64.S         |    7 ++++-
 drivers/xen/events.c               |    7 +++--
 6 files changed, 71 insertions(+), 8 deletions(-)

-- 
1.7.4.1

