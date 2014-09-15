Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbaIOUcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:32:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbaIOThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Walch <walch.martin@web.de>, Paul Bolle <pebolle@tiscali.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 007/114] media: sms: Remove CONFIG_ prefix from Kconfig symbols
Date: Mon, 15 Sep 2014 12:25:07 -0700
Message-Id: <20140915192641.656888622@linuxfoundation.org>
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

From: Paul Bolle <pebolle@tiscali.nl>

commit 3c4b422adb7694418848cefc2a4669d63192c649 upstream.

X-Patchwork-Delegate: mchehab@redhat.com
Remove the CONFIG_ prefix from two Kconfig symbols in a dependency for
SMS_SIANO_DEBUGFS. This prefix is invalid inside Kconfig files.

Note that the current (common sense) dependency on SMS_USB_DRV and
SMS_SDIO_DRV being equal ensures that SMS_SIANO_DEBUGFS will not
violate its constraints. These constraint are that:
- it should only be built if SMS_USB_DRV is set;
- it can't be builtin if USB support is modular.

So drop the dependency on SMS_USB_DRV, as it is unneeded.

Fixes: 6c84b214284e ("[media] sms: fix randconfig building error")

Reported-by: Martin Walch <walch.martin@web.de>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/common/siano/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/common/siano/Kconfig
+++ b/drivers/media/common/siano/Kconfig
@@ -22,8 +22,7 @@ config SMS_SIANO_DEBUGFS
 	bool "Enable debugfs for smsdvb"
 	depends on SMS_SIANO_MDTV
 	depends on DEBUG_FS
-	depends on SMS_USB_DRV
-	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV
+	depends on SMS_USB_DRV = SMS_SDIO_DRV
 
 	---help---
 	  Choose Y to enable visualizing a dump of the frontend


