Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3H0BNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:13:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab3H0BHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 65/74] SCSI: lpfc: Dont force CONFIG_GENERIC_CSUM on
Date: Mon, 26 Aug 2013 18:09:03 -0700
Message-Id: <20130827010437.763596273@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit f5944daa0a72316077435c18a6571e73ed338332 upstream.

We want ppc64 to be able to select between optimised assembly
checksum routines in big endian and the generic lib/checksum.c
routines in little endian.

The lpfc driver is forcing CONFIG_GENERIC_CSUM on which means
we are unable to make the decision to enable it in the arch
Kconfig. If the option exists it is always forced on.

This got introduced in 3.10 via commit 6a7252fdb0c3 ([SCSI] lpfc:
fix up Kconfig dependencies). I spoke to Randy about it and
the original issue was with CRC_T10DIF not being defined.

As such, remove the select of CONFIG_GENERIC_CSUM.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1353,7 +1353,6 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	select SCSI_FC_ATTRS
-	select GENERIC_CSUM
 	select CRC_T10DIF
 	help
           This lpfc driver supports the Emulex LightPulse


