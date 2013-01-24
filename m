Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab3AXVOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:14:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:40015 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030205Ab3AXVNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bian Yu <bianyu@kedacom.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 04/46] libata: ahci: Fix lack of command retry after a success error handler.
Date: Thu, 24 Jan 2013 13:12:42 -0800
Message-Id: <20130124211137.543244364@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bian Yu <bianyu@kedacom.com>

commit 1eaca39a84170b369fe61fb1da3c1e8606859e99 upstream.

It should be a mistake introduced by commit 8d899e70c1b3afff.

qc->flags can't be set AC_ERR_*

Signed-off-by: Bian Yu <bianyu@kedacom.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-eh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2094,7 +2094,7 @@ static unsigned int ata_eh_speed_down(st
  */
 static inline int ata_eh_worth_retry(struct ata_queued_cmd *qc)
 {
-	if (qc->flags & AC_ERR_MEDIA)
+	if (qc->err_mask & AC_ERR_MEDIA)
 		return 0;	/* don't retry media errors */
 	if (qc->flags & ATA_QCFLAG_IO)
 		return 1;	/* otherwise retry anything from fs stack */


