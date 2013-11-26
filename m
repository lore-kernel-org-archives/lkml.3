Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3KZS62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:58:28 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53923 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab3KZS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:58:25 -0500
From: Olof Johansson <olof@lixom.net>
To: linus.walleij@linaro.org
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] gpio: pl061: print resource_size_t as %pa
Date: Tue, 26 Nov 2013 10:56:01 -0800
Message-Id: <1385492161-27624-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 73675c8aa07 ('gpio: pl061: proper error messages') added a printout
of a resource_size_t using %x, which produces an error for builds with
64-bit resources:

drivers/gpio/gpio-pl061.c:345:3: warning: format '%x' expects argument of
    type 'unsigned int', but argument 3 has type 'resource_size_t'

Switch to %pa (and pass in a pointer to the resource instead).

Fixes: 73675c8aa07 ('gpio: pl061: proper error messages')
Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/gpio/gpio-pl061.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index f08e5e2cbe50..4ed16d7bd13d 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -341,8 +341,8 @@ static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	amba_set_drvdata(adev, chip);
-	dev_err(&adev->dev, "PL061 GPIO chip @%08x registered\n",
-		adev->res.start);
+	dev_err(&adev->dev, "PL061 GPIO chip @%pa registered\n",
+		&adev->res.start);
 
 	return 0;
 }
-- 
1.8.4.1.601.g02b3b1d

