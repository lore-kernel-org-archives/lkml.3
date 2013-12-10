Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3LJIBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:01:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3LJIBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 42/52] Input: mousedev - allow disabling even without CONFIG_EXPERT
Date: Tue, 10 Dec 2013 00:01:15 -0800
Message-Id: <20131210075957.147932589@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Gundersen <teg@jklm.no>

commit dfaaed08ecc01bd513248ba7999daf50ce028352 upstream.

Moust (if not all) modern software, including X, uses /dev/eventX rather than
the legacy /dev/mouseX devices. It therefore makes sense for general-purpose
(distro) kernels to use MOUSEDV=m (or even n), so let's drop the EXPERT=y
requirement.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -80,7 +80,7 @@ config INPUT_MATRIXKMAP
 comment "Userland interfaces"
 
 config INPUT_MOUSEDEV
-	tristate "Mouse interface" if EXPERT
+	tristate "Mouse interface"
 	default y
 	help
 	  Say Y here if you want your mouse to be accessible as char devices


