Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3IYAww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:52:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3IYATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:19:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 004/117] SCSI: Allow MPT Fusion SAS 3.0 driver to be built into the kernel
Date: Tue, 24 Sep 2013 17:17:50 -0700
Message-Id: <20130925001741.343451786@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 9807b4d94911be4e4efb9a08481b24292a9edf8a upstream.

Right now the Makefile for the mpt3sas driver does not even allow the
driver to be built into the kernel.  So fix that up, as there doesn't
seem to be any obvious reason why this shouldn't be done.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---
 drivers/scsi/mpt3sas/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -1,5 +1,5 @@
 # mpt3sas makefile
-obj-m += mpt3sas.o
+obj-$(CONFIG_SCSI_MPT3SAS) += mpt3sas.o
 mpt3sas-y +=  mpt3sas_base.o     \
 		mpt3sas_config.o \
 		mpt3sas_scsih.o      \


