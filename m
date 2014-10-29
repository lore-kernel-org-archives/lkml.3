Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbaJ2WjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:39:10 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61429 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbaJ2WjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:39:09 -0400
From: Behan Webster <behanw@converseincode.com>
To: micky_ching@realsil.com.cn
Cc: behanw@converseincode.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] staging, rts5208, LLVMLinux: Change extern inline to static inline
Date: Wed, 29 Oct 2014 15:38:42 -0700
Message-Id: <1414622322-19813-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With compilers which follow the C99 standard (like modern versions of gcc and
clang), "extern inline" does the opposite thing from older versions of gcc
(emits code for an externally linkable version of the inline function). "static
inline" does the intended behavior in both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rts5208/rtsx_transport.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5208/rtsx_transport.h b/drivers/staging/rts5208/rtsx_transport.h
index b4b1123..899bc20 100644
--- a/drivers/staging/rts5208/rtsx_transport.h
+++ b/drivers/staging/rts5208/rtsx_transport.h
@@ -46,7 +46,7 @@ void rtsx_add_cmd(struct rtsx_chip *chip,
 void rtsx_send_cmd_no_wait(struct rtsx_chip *chip);
 int rtsx_send_cmd(struct rtsx_chip *chip, u8 card, int timeout);
 
-extern inline u8 *rtsx_get_cmd_data(struct rtsx_chip *chip)
+static inline u8 *rtsx_get_cmd_data(struct rtsx_chip *chip)
 {
 #ifdef CMD_USING_SG
 	return (u8 *)(chip->host_sg_tbl_ptr);
-- 
1.9.1

