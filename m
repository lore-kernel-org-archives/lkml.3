Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaH1NQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:16:02 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:60041 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaH1NOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/11] mfd: wm5102: Insert missing break in case statement
Date: Thu, 28 Aug 2014 14:14:13 +0100
Message-Id: <1409231657-18294-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chip identifier wm5102_reva_patch is always overwritten with
wm5102_revb_patch, even when the code is run on a Rev-A chip.  Place
in the missing break to force the code into doing something sensible
instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/wm5102-tables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index fb4d4bb..a219888 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -87,6 +87,7 @@ int wm5102_patch(struct arizona *arizona)
 	case 0:
 		wm5102_patch = wm5102_reva_patch;
 		patch_size = ARRAY_SIZE(wm5102_reva_patch);
+		break;
 	default:
 		wm5102_patch = wm5102_revb_patch;
 		patch_size = ARRAY_SIZE(wm5102_revb_patch);
-- 
1.9.1

