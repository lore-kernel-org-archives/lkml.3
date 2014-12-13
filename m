Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaLMAyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 19:54:12 -0500
Received: from rs04.intra2net.com ([85.214.66.2]:51615 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaLMAyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 19:54:10 -0500
X-Greylist: delayed 1282 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2014 19:54:10 EST
Message-ID: <548B8928.7090502@intra2net.com>
Date: Sat, 13 Dec 2014 01:32:40 +0100
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: sparmaintainer@unisys.com
CC: linux-kernel@vger.kernel.org
Subject: [staging PATCH] Add missing va_end() call
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by cppcheck

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 drivers/staging/unisys/uislib/uisutils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index 8ff6d26..d821c82 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -59,6 +59,7 @@ uisutil_add_proc_line_ex(int *total, char **buffer, int *buffer_remaining,
 	DBGINF("buffer = 0x%p : *buffer = 0x%p.\n", buffer, *buffer);
 	va_start(args, format);
 	len = vsnprintf(*buffer, *buffer_remaining, format, args);
+	va_end(args);
 	if (len >= *buffer_remaining) {
 		*buffer += *buffer_remaining;
 		*total += *buffer_remaining;
-- 
1.9.3

