Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaJ1DhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:37:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbaJ1DhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.17 036/146] qla2xxx: fix kernel NULL pointer access
Date: Tue, 28 Oct 2014 11:32:58 +0800
Message-Id: <20141028033344.989067684@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

commit 78c2106a50e067f7168ee8c0944baaeb0e988272 upstream.

This patch is to fix regression added by commit id
51a07f84649d2be206c4c2ad9a612956db0c2f8c.

When allocating memory for new session original patch does
not assign vha to op->vha resulting into NULL pointer
access during qlt_create_sess_from_atio().

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3277,6 +3277,7 @@ static int qlt_handle_cmd_for_atio(struc
 			return -ENOMEM;
 
 		memcpy(&op->atio, atio, sizeof(*atio));
+		op->vha = vha;
 		INIT_WORK(&op->work, qlt_create_sess_from_atio);
 		queue_work(qla_tgt_wq, &op->work);
 		return 0;


