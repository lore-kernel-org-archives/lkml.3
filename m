Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBCGzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:55:46 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38359 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaBCGzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:55:45 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        patches@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v4 0/1] audit: generic compat system call support
Date: Mon,  3 Feb 2014 15:55:27 +0900
Message-Id: <1391410528-4844-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389945795-4255-1-git-send-email-takahiro.akashi@linaro.org>
References: <1389945795-4255-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arm64 supports 32-bit mode(AArch32) and 64-bit mode(AArch64).
To enable audit on arm64, we want to use lib/audit.c and re-work it
to support compat system calls as well without copying it under
arch sub-directory.

Since this patch is implemented in much the same way as on existing
bi-architectures (ie. ppc, s390, sparc and x86), it's not difficult
for them to utilize this generic code instead of their own implementation.

The code was tested on armv8 fast model with 64-bit and 32-bit userland
by using modified audit-test-code. As this patch is mandatory for my
"system call audit support for arm64" patch, please review it as well
for better understandings.

Changes v2 -> v3:
* Specify AUDIT_CLASS_XYZ_32 instead of AUDIT_CLASS_XYZ when registering
  compat syscalls (bug fix)

Changes v3 -> v4:
* Add CONFIG_AUDIT_COMPAT_GENERIC to compile in compat_audit.c
* Re-define audit_is_compat() in generic way in order to eliminate
  necessity of asm/audit.h.

AKASHI Takahiro (1):
  audit: Add generic compat syscall support

 include/linux/audit.h      |    8 +++++++
 include/uapi/linux/audit.h |    6 ++++++
 lib/Kconfig                |    5 +++++
 lib/Makefile               |    1 +
 lib/audit.c                |   15 ++++++++++++-
 lib/compat_audit.c         |   50 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 84 insertions(+), 1 deletion(-)
 create mode 100644 lib/compat_audit.c

-- 
1.7.9.5

