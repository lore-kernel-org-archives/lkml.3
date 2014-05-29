Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbaE2EoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:44:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbaE2Eir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lana Black <sickmind@lavabit.com>,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 71/86] net: qmi_wwan: fixup Sierra Wireless MC8305 entry
Date: Wed, 28 May 2014 21:37:46 -0700
Message-Id: <20140529043523.081126286@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 5a008ffa73b4401251d548c10cadac6f8a67cfb5 ]

The MC8305 module got an additional entry added based solely on
information from a Windows driver *.inf file. We now have the
actual descriptor layout from one of these modules, and it
consists of two alternate configurations where cfg #1 is a
normal Gobi 2k layout and cfg #2 is MBIM only, using interface
numbers 5 and 6 for MBIM control and data. The extra Windows
driver entry for interface number 5 was most likely a bug.

Deleting the bogus entry to avoid unnecessary qmi_wwan probe
failures when using the MBIM configuration.

Reported-by: Lana Black <sickmind@lavabit.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -760,7 +760,6 @@ static const struct usb_device_id produc
 	{QMI_GOBI_DEVICE(0x1199, 0x9009)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{QMI_GOBI_DEVICE(0x1199, 0x900a)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{QMI_GOBI_DEVICE(0x1199, 0x9011)},	/* Sierra Wireless Gobi 2000 Modem device (MC8305) */
-	{QMI_FIXED_INTF(0x1199, 0x9011, 5)},	/* alternate interface number!? */
 	{QMI_GOBI_DEVICE(0x16d8, 0x8002)},	/* CMDTech Gobi 2000 Modem device (VU922) */
 	{QMI_GOBI_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
 	{QMI_GOBI_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem device (MC8355) */


