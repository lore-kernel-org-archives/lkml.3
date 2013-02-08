Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab3BHA55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:57:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111Ab3BHA5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 13/34] mtd: davinci_nand: fix modular build with CONFIG_OF=y
Date: Thu,  7 Feb 2013 16:57:09 -0800
Message-Id: <20130208004629.729449530@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 7a9c83888761a9a26049b439dc0b09e7ea8a854b upstream.

Commit cdeadd712f52b16a9285386d61ee26fd14eb4085 (mtd: nand: davinci: add OF
support for davinci nand controller) has never been really build tested with
the driver as a module.  When the driver is built-in, the missing semicolon
after structure initializer is "compensated" by MODULE_DEVICE_TABLE() macro
being empty and so the initializer using the trailing semicolon on the next
line; when the driver is built as a module, compilation error ensues, and as
the 'davinci_all_defconfig' has the NAND driver modular, this error prevents
DaVinci family kernel from building...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/davinci_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -523,7 +523,7 @@ static struct nand_ecclayout hwecc4_2048
 static const struct of_device_id davinci_nand_of_match[] = {
 	{.compatible = "ti,davinci-nand", },
 	{},
-}
+};
 MODULE_DEVICE_TABLE(of, davinci_nand_of_match);
 
 static struct davinci_nand_pdata


