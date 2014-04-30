Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbaD3UYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:24:33 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:22677 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758905AbaD3UYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:24:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsGADRbYVNXQ3IO/2dsb2JhbABZgwaCQMMygSAXdIJmHCMYgQIkE4hFAaYmo2OOUYRAAQOPE4oTAZJrgzM7
Date: Wed, 30 Apr 2014 22:24:28 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] lib/vsprintf.c: fix comparison to bool
Message-Id: <20140430222428.c1e6cdb0936e53ed2eca95b6@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing 2 coccinelle warnings:
lib/vsprintf.c:2350:2-9: WARNING: Assignment of bool to 0/1
lib/vsprintf.c:2389:3-10: WARNING: Assignment of bool to 0/1

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/vsprintf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 0648291..6fe2c84 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2347,7 +2347,7 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 			break;
 
 		base = 10;
-		is_sign = 0;
+		is_sign = false;
 
 		switch (*fmt++) {
 		case 'c':
@@ -2386,7 +2386,7 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 		case 'i':
 			base = 0;
 		case 'd':
-			is_sign = 1;
+			is_sign = true;
 		case 'u':
 			break;
 		case '%':
-- 
1.9.1

