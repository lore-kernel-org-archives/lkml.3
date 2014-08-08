Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaHHN4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:56:43 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62395 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaHHN4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:56:41 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] driver core: Remove kerneldoc from local function
Date: Fri,  8 Aug 2014 15:56:36 +0200
Message-Id: <1407506196-7470-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407490591-15754-1-git-send-email-thierry.reding@gmail.com>
References: <1407490591-15754-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The deferred_probe_work_func() function is locally scoped, therefore an
associated kerneldoc comment isn't very useful. Replace the kerneldoc
opening marker (/**) with a regular block comment marker (/*) to avoid
the comment from being parsed by kerneldoc. This gets rid of a warning
caused by a missing description for the "work" argument.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- make comment non-kerneldoc rather than fixing it up

 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e4ffbcf2f519..cdc779cf79a3 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -54,7 +54,7 @@ static LIST_HEAD(deferred_probe_active_list);
 static struct workqueue_struct *deferred_wq;
 static atomic_t deferred_trigger_count = ATOMIC_INIT(0);
 
-/**
+/*
  * deferred_probe_work_func() - Retry probing devices in the active list.
  */
 static void deferred_probe_work_func(struct work_struct *work)
-- 
2.0.4

