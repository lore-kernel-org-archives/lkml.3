Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbaGOX3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:29:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759402AbaGOXOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Xuetao Guan <gxt@mprc.pku.edu.cn>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.15 75/84] drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue
Date: Tue, 15 Jul 2014 16:18:12 -0700
Message-Id: <20140715231715.423786550@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen.5i5j@gmail.com>

commit c863810cefc7ffd782e5648a21bfb36a32c8b081 upstream.

It is only a typo issue, the related commit:

  "1fbc4c4 drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()"

The related error (unicore32 with allmodconfig):

    CC [M]  drivers/rtc/rtc-puv3.o
  drivers/rtc/rtc-puv3.c: In function 'puv3_rtc_setpie':
  drivers/rtc/rtc-puv3.c:74: error: implicit declaration of function 'dev_debug'

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
Signed-off-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-puv3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -71,7 +71,7 @@ static int puv3_rtc_setpie(struct device
 {
 	unsigned int tmp;
 
-	dev_debug(dev, "%s: pie=%d\n", __func__, enabled);
+	dev_dbg(dev, "%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&puv3_rtc_pie_lock);
 	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;


