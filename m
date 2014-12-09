Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaLIL7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:59:19 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58043 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbaLIL6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:58:30 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>, Olof Johansson <olof@lixom.net>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 4/6] mfd: cros_ec: Instantiate ChromeOS EC character device
Date: Tue,  9 Dec 2014 12:57:46 +0100
Message-Id: <1418126268-12532-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418126268-12532-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1418126268-12532-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ChromeOS EC character device is an user-space interface to
allow applications to access the Embedded Controller.

Add a cell for this device so it's spawned from the mfd driver.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v1: None, new patch

 drivers/mfd/cros_ec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index c872e1b..70f9ed5 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -118,6 +118,10 @@ static const struct mfd_cell cros_devs[] = {
 		.id = 2,
 		.of_compatible = "google,cros-ec-i2c-tunnel",
 	},
+	{
+		.name = "cros-ec-dev",
+		.id = 3,
+	},
 };
 
 int cros_ec_register(struct cros_ec_device *ec_dev)
-- 
2.1.0

