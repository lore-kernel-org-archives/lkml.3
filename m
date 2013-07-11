Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3GKWDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:03:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3GKWBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:01:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 17/19] SCSI: sd: Fix parsing of temporary  cache mode prefix
Date: Thu, 11 Jul 2013 15:01:34 -0700
Message-Id: <20130711214832.574345473@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
References: <20130711214830.611455274@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 2ee3e26c673e75c05ef8b914f54fadee3d7b9c88 upstream.

Commit 39c60a0948cc '[SCSI] sd: fix array cache flushing bug causing
performance problems' added temp as a pointer to "temporary " and used
sizeof(temp) - 1 as its length.  But sizeof(temp) is the size of the
pointer, not the size of the string constant.  Change temp to a static
array so that sizeof() does what was intended.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -142,7 +142,7 @@ sd_store_cache_type(struct device *dev,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
-	const char *temp = "temporary ";
+	static const char temp[] = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)


