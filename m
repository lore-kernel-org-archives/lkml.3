Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644AbaE3UKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:10:30 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51921 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934432AbaE3UK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:10:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>,
        Brian Uchino <buchino@cisco.com>, linux-scsi@vger.kernel.org
Subject: [RFC 31/32] scsi: fnic: use current_kernel_time() for timestamp
Date: Fri, 30 May 2014 22:01:55 +0200
Message-Id: <1401480116-1973111-32-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:mxm904VUl64dtpoZflW78hL4BrxorDXa/oU4Xfe5atB
 n9lJOTECxnbzGrfXWTaZlUvNjr7vVDlNZC+vU9Gzl2s8RLTdPS
 KKi4WZbVlPR6YhdRGFDn79rxUH8RiPmMOKCPh1zyaFjgNYXxmV
 vQyewZAl1s3C/2OTQbizhZVx9Et54ZQsipz04oRp/5tUheGNFE
 m9P1MtsKOh3xt11gJE6w/p734xtaYyAoMWDT1rajFm8y3219M7
 nOX1gE5gFZ5LeJgckgh8n8slNIBlJWRy2cVR1AcKkF+cXcsTpC
 pAOAMyVwCVo3dV62Op/kenNHu6Q1paOkKOGCxDhHe4sd12ULe3
 YI8gx7BNbJPk5WqCHiylcF8hlyxrKIApzGf04v0Wj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fnic driver currently uses the CURRENT_TIME macro to
generate a timestamp. Since this is otherwise used only in
file system code and we want to change the type, it's
better for this driver to use the equivalent function that
continues to return a struct timespec.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/fnic/fnic_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index c772859..2659538 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -612,7 +612,7 @@ int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
 			fc_trace_entries.rd_idx = 0;
 	}
 
-	fc_buf->time_stamp = CURRENT_TIME;
+	fc_buf->time_stamp = current_kernel_time();
 	fc_buf->host_no = host_no;
 	fc_buf->frame_type = frame_type;
 
-- 
1.8.3.2

