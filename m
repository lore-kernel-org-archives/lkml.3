Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3LDFvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:51:06 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36102 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3LDFvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:51:03 -0500
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, Vijaya.Kumar@caviumnetworks.com,
        dsaxena@linaro.org, jason.wessel@windriver.com,
        steve.capper@linaro.org, Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Subject: [PATCH v4] ARM64 breakpoint and single step exception hooks
Date: Wed,  4 Dec 2013 11:20:19 +0530
Message-Id: <1386136220-15171-1-git-send-email-sandeepa.prabhu@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for breakpoint and single-step exception hooks.

v3 version of this patch is published and reviewed with arm64 kdgb and kprobes patch series [1] and [2]

[1] http://lwn.net/Articles/570648/
[2] https://lwn.net/Articles/571063/

Changes v3 -> v4:
 -Incorporated review comments: http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/207372.html
    -Removed unnecessary comments
    -Added comments for breakpoint re-entrancy & rw locks
 - Rebased on top of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git Branch:upstream
commit ID: dc1ccc48159d63eca5089e507c82c7d22ef60839  (Linux 3.13-rc2)
 - CCing Jason Wessel, since arm64 kgdb patchset is dependant on this.

Sandeepa Prabhu (1):
  arm64: support single-step and breakpoint handler hooks

 arch/arm64/include/asm/debug-monitors.h | 21 ++++++++
 arch/arm64/kernel/debug-monitors.c      | 88 ++++++++++++++++++++++++++++++++-
 arch/arm64/kernel/entry.S               |  2 +
 3 files changed, 110 insertions(+), 1 deletion(-)

-- 
1.8.1.2

