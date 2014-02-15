Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaBOJpc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 04:45:32 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:57166 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaBOJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 04:45:29 -0500
From: Levente Kurusa <levex@linux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Micky Ching <micky_ching@realsil.com.cn>
Cc: LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        David Binderman <dcb314@hotmail.com>, Levente Kurusa <levex@linux.com>
Subject: [PATCH] staging: rts5208: fix always true condition
Date: Sat, 15 Feb 2014 10:44:35 +0100
Message-Id: <1392457475-27693-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ANDing anything with 0x1E and expecting it to be not 0x03 will always
be true. AND instead with 0x03, so that we check the last two bits,
which should be what was intended there.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/staging/rts5208/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5208/sd.c b/drivers/staging/rts5208/sd.c
index c7c1f54..03548e5 100644
--- a/drivers/staging/rts5208/sd.c
+++ b/drivers/staging/rts5208/sd.c
@@ -3512,7 +3512,7 @@ RTY_SEND_CMD:
 					TRACE_RET(chip, STATUS_FAIL);
 
 			} else if (rsp_type == SD_RSP_TYPE_R0) {
-				if ((ptr[3] & 0x1E) != 0x03)
+				if ((ptr[3] & 0x03) != 0x03)
 					TRACE_RET(chip, STATUS_FAIL);
 			}
 		}
-- 
1.8.3.1

