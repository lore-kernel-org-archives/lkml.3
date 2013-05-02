Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3EBByB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:54:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38642 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3EBBx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:53:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, rjw@sisk.pl,
        pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Subject: [RFC] Fix restore from hibernate with different kernel versions.
Date: Wed,  1 May 2013 21:53:29 -0400
Message-Id: <1367459610-9656-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is intended for v3.10 and it should be considered RFC as I had
only tested it under QEMU and not real hardware (that to be done on Friday).

The patch addresses a shortcomming of the git commite
7a5cd063c7b4c58417f674821d63f5eb6747e37 ("x86-64, gdt: Store/load GDT for
ACPI S3 or hibernate/resume path is not needed.") where its assumption
about restoring a kernel was incorrect. Specifically it assumed that a resumed
kernel MUST be the same as the one booted. That is only true for 32-bit
kernels but not for 64-bit.

And as such it introduces a regression which the attached patch is
fixing.

The patch goes further and also lays the groundwork to make this work under
a 32-bit kernel - even though it is not neccessary. This is done to unify
the 32 and 64-bit code and make it easier in the future to unify the
respective code closer.


 arch/x86/include/asm/suspend_32.h |  1 +
 arch/x86/include/asm/suspend_64.h |  2 ++
 arch/x86/kernel/asm-offsets_32.c  |  3 +++
 arch/x86/kernel/asm-offsets_64.c  |  1 +
 arch/x86/power/cpu.c              | 15 ++++++++++-----
 arch/x86/power/hibernate_asm_32.S |  4 ++++
 arch/x86/power/hibernate_asm_64.S |  3 +++
 7 files changed, 24 insertions(+), 5 deletions(-)

Konrad Rzeszutek Wilk (1):
      x86, x86-64, gdt, hibernate: Store/load GDT for hibernate path.

