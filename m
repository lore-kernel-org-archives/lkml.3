Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaBYJPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:15:40 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37517 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaBYJPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:15:38 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v2 0/1] arm64: make a single hook to syscall_trace() for all syscall features
Date: Tue, 25 Feb 2014 18:14:42 +0900
Message-Id: <1393319683-2707-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391767651-5296-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391767651-5296-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it easy to add syscall related hooks, including ftrace,
audit and seccomp, in syscall_trace() later.
Those features will be implemented in separate patchsets, but it's safe to
check for all TIF_* now because they can not be turned on anyway.

Changes v1 -> v2:
* added a guard against TIF_SYSCALL_TRACE at tracehook_report_syscall_*()
* renamed _TIF_WORK_SYSCALL to _TIF_SYSCALL_WORK

AKASHI Takahiro (1):
  arm64: make a single hook to syscall_trace() for all syscall features

 arch/arm64/include/asm/thread_info.h |   13 ++++++++++
 arch/arm64/kernel/entry.S            |    5 ++--
 arch/arm64/kernel/ptrace.c           |   45 +++++++++++++++++-----------------
 3 files changed, 38 insertions(+), 25 deletions(-)

-- 
1.7.9.5

