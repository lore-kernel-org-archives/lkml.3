Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbaHHUyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:54:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbaHHUx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ted Juan <ted.juan@gmail.com>, Brian Norris <computersforpeace@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 117/259] mtd: devices: elm: fix elm_context_save() and elm_context_restore() functions
Date: Fri,  8 Aug 2014 13:39:00 -0700
Message-Id: <1407530482-4483-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ted Juan <ted.juan@gmail.com>

commit 6938ad40cb97a52d88a763008935340729a4acc7 upstream.

These two function's switch case lack the 'break' that make them always
return error.

Signed-off-by: Ted Juan <ted.juan@gmail.com>
Acked-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/devices/elm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/devices/elm.c b/drivers/mtd/devices/elm.c
index d1dd6a3..3059a7a 100644
--- a/drivers/mtd/devices/elm.c
+++ b/drivers/mtd/devices/elm.c
@@ -428,6 +428,7 @@ static int elm_context_save(struct elm_info *info)
 					ELM_SYNDROME_FRAGMENT_1 + offset);
 			regs->elm_syndrome_fragment_0[i] = elm_read_reg(info,
 					ELM_SYNDROME_FRAGMENT_0 + offset);
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -466,6 +467,7 @@ static int elm_context_restore(struct elm_info *info)
 					regs->elm_syndrome_fragment_1[i]);
 			elm_write_reg(info, ELM_SYNDROME_FRAGMENT_0 + offset,
 					regs->elm_syndrome_fragment_0[i]);
+			break;
 		default:
 			return -EINVAL;
 		}
-- 
1.9.1

