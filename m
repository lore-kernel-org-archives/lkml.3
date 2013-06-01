Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab3FAJnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:43:01 -0400
Received: from www17.your-server.de ([213.133.104.17]:59050 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab3FAJmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:42:55 -0400
Message-ID: <1370079770.29224.13.camel@localhost.localdomain>
Subject: [PATCH] x86/mrst: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:42:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -356,10 +356,9 @@ static int __init sfi_parse_gpio(struct
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
 	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
 
-	gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
+	gpio_table = kmemdup(pentry, num * sizeof(*pentry), GFP_KERNEL);
 	if (!gpio_table)
 		return -1;
-	memcpy(gpio_table, pentry, num * sizeof(*pentry));
 	gpio_num_entry = num;
 
 	pr_debug("GPIO pin info:\n");
@@ -744,13 +743,12 @@ static void __init intel_scu_spi_device_
 		return;
 	}
 
-	new_dev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	new_dev = kmemdup(sdev, sizeof(*sdev), GFP_KERNEL);
 	if (!new_dev) {
 		pr_err("failed to alloc mem for delayed spi dev %s\n",
 			sdev->modalias);
 		return;
 	}
-	memcpy(new_dev, sdev, sizeof(*sdev));
 
 	spi_devs[spi_next_dev++] = new_dev;
 }
@@ -765,13 +763,12 @@ static void __init intel_scu_i2c_device_
 		return;
 	}
 
-	new_dev = kzalloc(sizeof(*idev), GFP_KERNEL);
+	new_dev = kmemdup(idev, sizeof(*idev), GFP_KERNEL);
 	if (!new_dev) {
 		pr_err("failed to alloc mem for delayed i2c dev %s\n",
 			idev->type);
 		return;
 	}
-	memcpy(new_dev, idev, sizeof(*idev));
 
 	i2c_bus[i2c_next_dev] = bus;
 	i2c_devs[i2c_next_dev++] = new_dev;


