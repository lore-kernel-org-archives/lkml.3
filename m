Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887Ab3EFXWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:22:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab3EFXN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>, Alexander Graf <agraf@suse.de>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 077/104] sata_highbank: Rename proc_name to the module name
Date: Mon,  6 May 2013 16:12:36 -0700
Message-Id: <20130506230051.573763064@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@calxeda.com>

commit 2cc1144a31f76d4a9fb48bec5d6ba1359f980813 upstream.

mkinitrd looks at /sys/class/scsi_host/host$hostnum/proc_name to find
the module name of a disk driver. Current name is "highbank-ahci" but
the module is "sata_highbank". Rename it to match the module name.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Alexander Graf <agraf@suse.de>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_highbank.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -251,7 +251,7 @@ static const struct ata_port_info ahci_h
 };
 
 static struct scsi_host_template ahci_highbank_platform_sht = {
-	AHCI_SHT("highbank-ahci"),
+	AHCI_SHT("sata_highbank"),
 };
 
 static const struct of_device_id ahci_of_match[] = {


