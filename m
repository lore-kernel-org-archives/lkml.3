Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbbAVTQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:16:51 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36195 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbbAVTQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:16:47 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 5/7] mfd: cros_ec: Instantiate ChromeOS EC character device
Date: Thu, 22 Jan 2015 20:16:24 +0100
Message-Id: <1421954186-29764-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ChromeOS EC character device is an user-space interface to
allow applications to access the Embedded Controller.

Add a cell for this device so it's spawned from the mfd driver.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v2:
 - Rename the name to "cros-ec-ctl". Suggested by Lee Jones.

Changes since v1: None, new patch.
---
 drivers/mfd/cros_ec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index c872e1b0eaf8..c4aecc6f8373 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -118,6 +118,10 @@ static const struct mfd_cell cros_devs[] = {
 		.id = 2,
 		.of_compatible = "google,cros-ec-i2c-tunnel",
 	},
+	{
+		.name = "cros-ec-ctl",
+		.id = 3,
+	},
 };
 
 int cros_ec_register(struct cros_ec_device *ec_dev)
-- 
2.1.3

