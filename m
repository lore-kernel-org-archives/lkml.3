Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaKREkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:40:55 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64422 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaKREkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:40:53 -0500
From: Srikanth Thokala <sriku.linux@gmail.com>
To: corbet@lwn.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srikanth Thokala <sriku.linux@gmail.com>
Subject: [PATCH] Documentation: memory-barriers: Fix typo in the first example
Date: Tue, 18 Nov 2014 10:09:58 +0530
Message-Id: <1416285598-6630-1-git-send-email-sriku.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the first example, the loads into 'x' and 'y' on CPU 2 doesn't
match the sequence of events described below it.  To match the
sequence of events, the values of 'A' and 'B' should be loaded
into 'x' and 'y' respectively.

Signed-off-by: Srikanth Thokala <sriku.linux@gmail.com>
---
 Documentation/memory-barriers.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 22a969c..2770bce 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -115,8 +115,8 @@ For example, consider the following sequence of events:
 	CPU 1		CPU 2
 	===============	===============
 	{ A == 1; B == 2 }
-	A = 3;		x = B;
-	B = 4;		y = A;
+	A = 3;		x = A;
+	B = 4;		y = B;
 
 The set of accesses as seen by the memory system in the middle can be arranged
 in 24 different combinations:
-- 
1.9.1

