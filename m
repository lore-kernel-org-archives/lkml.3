Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbaFAL3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 07:29:53 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42476 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaFAL3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 07:29:51 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Cort <linuxgeek@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: rtl871x_ioctl_linux.c:  Cleaning up memory leak
Date: Sun,  1 Jun 2014 13:30:43 +0200
Message-Id: <1401622243-13364-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk for memory leak in when something unexpected happens
and the function returns.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 23d539d..27e0243 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1822,6 +1822,7 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
 		alg_name = "CCMP";
 		break;
 	default:
+		kfree(param);
 		return -EINVAL;
 	}
 	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
-- 
1.7.10.4

