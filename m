Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551AbaBDW3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:29:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844AbaBDVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 034/133] rtlwifi: Increase the RX queue length for USB drivers
Date: Tue,  4 Feb 2014 13:07:15 -0800
Message-Id: <20140204210737.995782213@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit dc6405712268fe514d3dd89aa936c4397b0871b9 upstream.

The current number of RX buffers queued is 32, which is too small under
heavy load. That number is doubled.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -557,7 +557,7 @@ static void _rtl_rx_pre_process(struct i
 	}
 }
 
-#define __RX_SKB_MAX_QUEUED	32
+#define __RX_SKB_MAX_QUEUED	64
 
 static void _rtl_rx_work(unsigned long param)
 {


