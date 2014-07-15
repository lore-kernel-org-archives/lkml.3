Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232AbaGOXOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:14:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933568AbaGOXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Xuetao Guan <gxt@mprc.pku.edu.cn>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.14 56/66] drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue
Date: Tue, 15 Jul 2014 16:17:50 -0700
Message-Id: <20140715231704.551344609@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231702.156040999@linuxfoundation.org>
References: <20140715231702.156040999@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen.5i5j@gmail.com>

commit 73fa540618d8b1f8c2266934f23bd84bb9e28d9e upstream.

It is only a typo issue, the related commit:

  "1fbc4c4 drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()"

The related error (for unicore32 with allmodconfig):

    CC [M]  drivers/rtc/rtc-puv3.o
  drivers/rtc/rtc-puv3.c: In function 'puv3_rtc_setalarm':
  drivers/rtc/rtc-puv3.c:143: error: 'struct device' has no member named 'dev'

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
@@ -140,7 +140,7 @@ static int puv3_rtc_setalarm(struct devi
 	rtc_tm_to_time(tm, &rtcalarm_count);
 	writel(rtcalarm_count, RTC_RTAR);
 
-	puv3_rtc_setaie(&dev->dev, alrm->enabled);
+	puv3_rtc_setaie(dev, alrm->enabled);
 
 	if (alrm->enabled)
 		enable_irq_wake(puv3_rtc_alarmno);


