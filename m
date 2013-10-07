Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3JGPVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:21:25 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:47715 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3JGPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:20:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the random tree
Date: Mon,  7 Oct 2013 17:18:46 +0200
Message-Id: <1381159127-11067-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381159127-11067-1-git-send-email-treding@nvidia.com>
References: <1381159127-11067-1-git-send-email-treding@nvidia.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the random tree got a conflict in:

	drivers/char/random.c

caused by commits 5573604 (random: push extra entropy to the output pools)
and 0244ad0 (Remove GENERIC_HARDIRQ config option). I fixed it up (see
below). Please verify that the resolution looks correct.

Thanks,
Thierry
---
diff --cc drivers/char/random.c
index 7737b5b,f126bd2..7cfc146
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@@ -255,8 -255,12 +255,9 @@@
  #include <linux/fips.h>
  #include <linux/ptrace.h>
  #include <linux/kmemcheck.h>
 +#include <linux/irq.h>
+ #include <linux/workqueue.h>
  
 -#ifdef CONFIG_GENERIC_HARDIRQS
 -# include <linux/irq.h>
 -#endif
 -
  #include <asm/processor.h>
  #include <asm/uaccess.h>
  #include <asm/irq.h>
