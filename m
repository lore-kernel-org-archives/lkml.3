Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab3E1D4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52595 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758892Ab3E1DyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jingoo Han" <jg1.han@samsung.com>,
        "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.991775316@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [91/94] drivers/rtc/rtc-pcf2123.c: fix error return code in
 pcf2123_probe()
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 35623715818dfa720cccf99cd280dcbb4b78da23 upstream.

Fix to return -ENODEV in the chip not found error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-pcf2123.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -264,6 +264,7 @@ static int __devinit pcf2123_probe(struc
 
 	if (!(rxbuf[0] & 0x20)) {
 		dev_err(&spi->dev, "chip not found\n");
+		ret = -ENODEV;
 		goto kfree_exit;
 	}
 

