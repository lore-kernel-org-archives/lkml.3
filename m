Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbbAGCnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:43:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980AbbAGCHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sumit Saxena <sumit.saxena@avagotech.com>,
        Kashyap Desai <kashyap.desai@avagotech.com>,
        Tomas Henzl <thenzl@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 11/52] megaraid_sas: corrected return of wait_event from abort frame path
Date: Tue,  6 Jan 2015 18:06:39 -0800
Message-Id: <20150107020556.919486628@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>

commit 170c238701ec38b1829321b17c70671c101bac55 upstream.

Corrected wait_event() call which was waiting for wrong completion
status (0xFF).

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -953,7 +953,7 @@ megasas_issue_blocked_abort_cmd(struct m
 		cpu_to_le32(upper_32_bits(cmd_to_abort->frame_phys_addr));
 
 	cmd->sync_cmd = 1;
-	cmd->cmd_status = 0xFF;
+	cmd->cmd_status = ENODATA;
 
 	instance->instancet->issue_dcmd(instance, cmd);
 


