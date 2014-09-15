Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbaIOUfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:35:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbaIOTg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3.14 016/114] tpm: Properly clean sysfs entries in error path
Date: Mon, 15 Sep 2014 12:25:16 -0700
Message-Id: <20140915192641.933815617@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.vnet.ibm.com>

commit b49e1043c48dac23f64fba684d31c4a96c1ffaa0 upstream.

Properly clean the sysfs entries in the error path

Reported-by: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm-interface.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1116,7 +1116,7 @@ struct tpm_chip *tpm_register_hardware(s
 		goto del_misc;
 
 	if (tpm_add_ppi(&dev->kobj))
-		goto del_misc;
+		goto del_sysfs;
 
 	chip->bios_dir = tpm_bios_log_setup(chip->devname);
 
@@ -1127,6 +1127,8 @@ struct tpm_chip *tpm_register_hardware(s
 
 	return chip;
 
+del_sysfs:
+	tpm_sysfs_del_device(chip);
 del_misc:
 	tpm_dev_del_device(chip);
 put_device:


