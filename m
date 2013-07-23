Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778Ab3GWW1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717Ab3GWW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 070/103] b43: ensue that BCMA is "y" when B43 is "y"
Date: Tue, 23 Jul 2013 15:26:21 -0700
Message-Id: <20130723220427.227961426@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hauke Mehrtens <hauke@hauke-m.de>

commit 693026ef2e751fd94d2e6c71028e68343cc875d5 upstream.

When b43 gets build into the kernel and it should use bcma we have to
ensure that bcma was also build into the kernel and not as a module.
In this patch this is also done for SSB, although you can not
build b43 without ssb support for now.

This fixes a build problem reported by Randy Dunlap in
5187EB95.2060605@infradead.org

Reported-By: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -28,7 +28,7 @@ config B43
 
 config B43_BCMA
 	bool "Support for BCMA bus"
-	depends on B43 && BCMA
+	depends on B43 && (BCMA = y || BCMA = B43)
 	default y
 
 config B43_BCMA_EXTRA
@@ -39,7 +39,7 @@ config B43_BCMA_EXTRA
 
 config B43_SSB
 	bool
-	depends on B43 && SSB
+	depends on B43 && (SSB = y || SSB = B43)
 	default y
 
 # Auto-select SSB PCI-HOST support, if possible


