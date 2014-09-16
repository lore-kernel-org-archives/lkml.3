Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaIPUyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:54:03 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:46631 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbaIPUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:21 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org
Subject: [PATCH 20/22] staging: r8188eu: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:34 +0200
Message-Id: <1410900696-6481-21-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/rtl8188eu/os_dep/rtw_android.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/rtw_android.c b/drivers/staging/rtl8188eu/os_dep/rtw_android.c
index ca2736d..2b5ddc3 100644
--- a/drivers/staging/rtl8188eu/os_dep/rtw_android.c
+++ b/drivers/staging/rtl8188eu/os_dep/rtw_android.c
@@ -79,7 +79,7 @@ int rtw_android_cmdstr_to_num(char *cmdstr)
 {
 	int cmd_num;
 	for (cmd_num = 0; cmd_num < ANDROID_WIFI_CMD_MAX; cmd_num++)
-		if (0 == strnicmp(cmdstr , android_wifi_cmd_str[cmd_num],
+		if (0 == strncasecmp(cmdstr , android_wifi_cmd_str[cmd_num],
 				  strlen(android_wifi_cmd_str[cmd_num])))
 			break;
 	return cmd_num;
-- 
2.0.4

