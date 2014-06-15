Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaFORUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:20:09 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:59059 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaFORUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:20:04 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Cort <linuxgeek@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: rtl871x_ioctl_linux.c:  Cleaning up useless if statement
Date: Sun, 15 Jun 2014 19:20:58 +0200
Message-Id: <1402852858-1352-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402852858-1352-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402852858-1352-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same code regardless of the outcome of the if statement.
And clean up another duplicate line of code.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 23d539d..bd82bd3 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1465,17 +1465,12 @@ static int r8711_wx_get_rate(struct net_device *dev,
 				RTL8712_RF_2T2R == rf_type)
 				max_rate = (bw_40MHz) ? ((short_GI) ? 300 :
 					    270) : ((short_GI) ? 144 : 130);
-			else if (mcs_rate & 0x0080) /* MCS7 */
-				max_rate = (bw_40MHz) ? ((short_GI) ? 150 :
-					    135) : ((short_GI) ? 72 : 65);
 			else /* default MCS7 */
 				max_rate = (bw_40MHz) ? ((short_GI) ? 150 :
 					    135) : ((short_GI) ? 72 : 65);
 			max_rate *= 2; /* Mbps/2 */
-			wrqu->bitrate.value = max_rate * 500000;
-		} else {
-			wrqu->bitrate.value = max_rate * 500000;
 		}
+		wrqu->bitrate.value = max_rate * 500000;
 	} else
 		return -ENOLINK;
 	return 0;
-- 
1.7.10.4

