Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaAQILl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:11:41 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53301 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaAQILi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:11:38 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3] audit: generic compat system call support
Date: Fri, 17 Jan 2014 17:11:23 +0900
Message-Id: <1389946284-4428-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arm64 supports 32-bit mode(AArch32) and 64-bit mode(AArch64).
To enable audit on arm64, we want to use lib/audit.c and re-work it
to support compat system calls as well without copying it under
arch sub-directory.

So this patch is mandatory for my "system call audit support for arm64"
patch. Please review it as well for better understandings.

This code was tested on armv8 fast model with 64-bit and 32-bit userland
by using modified audit-test-code.

Changes v1 -> v2:
* Specify AUDIT_CLASS_XYZ_32 instead of AUDIT_CLASS_XYZ when registering
  compat syscalls (bug fix)


AKASHI Takahiro (1):
  audit: Add generic compat syscall support

 include/linux/audit.h |    9 +++++++++
 lib/Makefile          |    3 +++
 lib/audit.c           |   17 +++++++++++++++++
 lib/compat_audit.c    |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+)
 create mode 100644 lib/compat_audit.c

-- 
1.7.9.5

