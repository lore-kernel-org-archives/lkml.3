Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbbA2NgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:36:09 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42873 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbbA2NgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:36:07 -0500
From: Anshul Garg <aksgarg1989@gmail.com>
X-Google-Original-From: Anshul Garg
To: linux-kernel@vger.kernel.org
Cc: aksgarg1989@gmail.com, anshul.g@samsung.com
Subject: [PATCH] lib/int_sqrt.c: Optimize square root function
Date: Thu, 29 Jan 2015 05:35:25 -0800
Message-Id: <1422538525-87669-1-git-send-email-aksgarg1989@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <aksgarg1989@gmail.com>
References: <aksgarg1989@gmail.com>
X-Antivirus: avast! (VPS 150129-0, 01/29/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anshul Garg <aksgarg1989@gmail.com>

Unnecessary instructions are executing even though m is
greater than x so added logic to make m less than equal to
x before performing these operations.

Signed-off-by: Anshul Garg <aksgarg1989@gmail.com>
---
 lib/int_sqrt.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/int_sqrt.c b/lib/int_sqrt.c
index 1ef4cc3..64ae722 100644
--- a/lib/int_sqrt.c
+++ b/lib/int_sqrt.c
@@ -22,6 +22,9 @@ unsigned long int_sqrt(unsigned long x)
 		return x;
 
 	m = 1UL << (BITS_PER_LONG - 2);
+
+	while (m > x)
+		m >>= 2;
 	while (m != 0) {
 		b = y + m;
 		y >>= 1;
-- 
1.7.9.5


---
This email has been checked for viruses by Avast antivirus software.
http://www.avast.com

