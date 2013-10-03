Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3JCJr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:26 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61272 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3JCJq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:46:58 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@linaro.org>, rtc-linux@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/9] rtc: amba: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:27 +0200
Message-Id: <c9c7ff49f1f9b42a5cd31ce988102c067c9afaa1.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4112-1380793614-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4112-1380793614-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/rtc/rtc-pl030.c | 2 --
 drivers/rtc/rtc-pl031.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index 22bacdb..a804f75 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -153,8 +153,6 @@ static int pl030_remove(struct amba_device *dev)
 {
 	struct pl030_rtc *rtc = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	writel(0, rtc->base + RTC_CR);

 	free_irq(dev->irq[0], rtc);
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 0f0609b..c9ca86e 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -305,7 +305,6 @@ static int pl031_remove(struct amba_device *adev)
 {
 	struct pl031_local *ldata = dev_get_drvdata(&adev->dev);

-	amba_set_drvdata(adev, NULL);
 	free_irq(adev->irq[0], ldata);
 	rtc_device_unregister(ldata->rtc);
 	iounmap(ldata->base);
@@ -392,7 +391,6 @@ out_no_irq:
 	rtc_device_unregister(ldata->rtc);
 out_no_rtc:
 	iounmap(ldata->base);
-	amba_set_drvdata(adev, NULL);
 out_no_remap:
 	kfree(ldata);
 out:
--
1.8.2.3


--=_mimegpg-monstr-desktop-4112-1380793614-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPQ4ACgkQykllyylKDCEDWwCeJRuilL3T5YT2U7p/hd2WadFK
eKEAn3DryHeGwXBtLuDo+a26tKGPJgv/
=goAX
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4112-1380793614-0001--
