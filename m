Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab3FCWOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:14:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13545 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146Ab3FCWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:45 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=YCIeOMuxQdYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6Au5JRGzgwoA:10 a=YhdJeHolAAAA:8 a=hD80L64hAAAA:8 a=Z4Rwk6OoAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=v3rLFGiuRE8A:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221200.478296464@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [48/65] drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0048-drivers-rtc-rtc-pcf2123.c-fix-error-return-code-in-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit 35623715818dfa720cccf99cd280dcbb4b78da23 ]

Fix to return -ENODEV in the chip not found error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/rtc/rtc-pcf2123.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 13e4df6..8620cbc 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -265,6 +265,7 @@ static int __devinit pcf2123_probe(struct spi_device *spi)
 
 	if (!(rxbuf[0] & 0x20)) {
 		dev_err(&spi->dev, "chip not found\n");
+		ret = -ENODEV;
 		goto kfree_exit;
 	}
 
-- 
1.7.10.4


