Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaD0RWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:22:44 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47995 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaD0RHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:52 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 13/47] staging/lustre/gss: fix uninitialized variable
Date: Sun, 27 Apr 2014 13:06:37 -0400
Message-Id: <1398618431-29757-14-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

'sg->page_link' is used uninitialized in many functions.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9325
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
index d03f6c1..2cc78b0 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
@@ -525,6 +525,7 @@ void gss_delete_sec_context_kerberos(void *internal_ctx)
 static
 void buf_to_sg(struct scatterlist *sg, void *ptr, int len)
 {
+	sg_init_table(sg, 1);
 	sg_set_buf(sg, ptr, len);
 }
 
-- 
1.8.5.3

