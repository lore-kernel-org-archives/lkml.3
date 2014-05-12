Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaELBlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:07 -0400
Received: from 1wt.eu ([62.212.114.60]:34275 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaELBlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:03 -0400
Message-Id: <20140512003200.680156035@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Bork <tom@eisfair.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 001/143] scsi: fix missing include linux/types.h in scsi_netlink.h
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bork <tom@eisfair.net>

Thomas Bork reported that commit c6203cd ("scsi: use __uX
types for headers exported to user space") caused a regression
as now he's getting this warning :

> /usr/src/linux-2.6.32-eisfair-1/usr/include/scsi/scsi_netlink.h:108:
> found __[us]{8,16,32,64} type without #include <linux/types.h>

This issue was addressed later by commit 10db4e1 ("headers:
include linux/types.h where appropriate"), so let's just pick the
relevant part from it.

Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/scsi/scsi_netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 58ce8fe..5cb20cc 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -23,7 +23,7 @@
 #define SCSI_NETLINK_H
 
 #include <linux/netlink.h>
-
+#include <linux/types.h>
 
 /*
  * This file intended to be included by both kernel and user space
-- 
1.7.12.2.21.g234cd45.dirty



