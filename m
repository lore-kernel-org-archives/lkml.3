Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3JCEtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:49:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3JCEUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:20:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 57/57] irq: Always define devm_{request_threaded,free}_irq()
Date: Wed,  2 Oct 2013 21:09:23 -0700
Message-Id: <20131003040640.490827345@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This is only needed for 3.11, as s390 has now been changed to use the
generic IRQ code upstream.

These functions are currently defined only if CONFIG_GENERIC_HARDIRQS
is enabled.  But they are still needed on s390 which has its own IRQ
management.

References: https://buildd.debian.org/status/fetch.php?pkg=linux&arch=s390&ver=3.11%7Erc4-1%7Eexp1&stamp=1376009959
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/Makefile     |    2 +-
 kernel/irq/Makefile |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -79,7 +79,7 @@ obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += debug/
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
-obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
+obj-y += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,8 +1,10 @@
-
-obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
+obj-y += devres.o
+ifdef CONFIG_GENERIC_HARDIRQS
+obj-y += irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o
 obj-$(CONFIG_GENERIC_IRQ_CHIP) += generic-chip.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
+endif


