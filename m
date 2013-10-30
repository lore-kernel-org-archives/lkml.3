Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750784Ab3J3EJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 00:09:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:45217 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab3J3EJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 00:09:07 -0400
X-Spam-Score: -100.8
Message-ID: <52708623.504@asianux.com>
Date: Wed, 30 Oct 2013 12:08:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/linux/wait.h: add ';' for the statement which missed
 it.
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ';' for the statement, or can not pass compiling. The related error
(for powerpc allmodconfig):

    CC      block/blk-mq.o
  block/blk-mq.c: In function ‘blk_mq_queue_enter’:
  block/blk-mq.c:108:8: error: expected ‘;’ before ‘__ret’
  block/blk-mq.c:108:6: error: void value not ignored as it ought to be


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/wait.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 7f8caa5..fcc9680 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -768,7 +768,7 @@ do {									\
 	int __ret = 0;							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible_lock_irq(wq,		\
-						condition, lock,)	\
+						condition, lock,);	\
 	__ret;								\
 })
 
-- 
1.7.7.6
