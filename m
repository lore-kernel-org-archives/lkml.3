Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbbAGBzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:55:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbbAGBwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sumit Saxena <sumit.saxena@avagotech.com>,
        Kashyap Desai <kashyap.desai@avagotech.com>,
        Tomas Henzl <thenzl@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.10 09/38] megaraid_sas: corrected return of wait_event from abort frame path
Date: Tue,  6 Jan 2015 17:50:21 -0800
Message-Id: <20150107014953.979624692@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014952.440109372@linuxfoundation.org>
References: <20150107014952.440109372@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -933,7 +933,7 @@ megasas_issue_blocked_abort_cmd(struct m
 	abort_fr->abort_mfi_phys_addr_hi = 0;
 
 	cmd->sync_cmd = 1;
-	cmd->cmd_status = 0xFF;
+	cmd->cmd_status = ENODATA;
 
 	instance->instancet->issue_dcmd(instance, cmd);
 


