Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3EYQyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 12:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab3EYQyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 12:54:13 -0400
Date: Sat, 25 May 2013 12:54:08 -0400
From: Kyle McMartin <kyle@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] score: remove redundant kcore_list entries
Message-ID: <20130525165405.GB30204@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcore_vmalloc is in fs/proc/kcore.c and kcore_mem is unused across
the tree. Noticed while grepping the tree for some other kcore stuff.

(score looks pretty unmaintained to me.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -41,8 +41,6 @@
 unsigned long empty_zero_page;
 EXPORT_SYMBOL_GPL(empty_zero_page);
 
-static struct kcore_list kcore_mem, kcore_vmalloc;
-
 static void setup_zero_page(void)
 {
 	struct page *page;
