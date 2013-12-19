Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3LSMYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:24:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3LSL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 134/208] [media] bttv: don't setup the controls if there are no video devices
Date: Thu, 19 Dec 2013 11:53:52 +0000
Message-Id: <1387454106-19326-135-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit f8e1b699a5504a2da05834c7cfdddb125a8ce088 upstream.

The no_video flag was checked in all other cases except one. Calling
v4l2_ctrl_handler_setup() if no_video is 1 will crash.
This wasn't noticed before since there are only two card types that
set no_video to 1, so this type of hardware is quite rare.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Lorenz Röhrl <sheepshit@gmx.de>
Tested-by: Lorenz Röhrl <sheepshit@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index c6532de..4f0aaa5 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4182,7 +4182,8 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	}
 	btv->std = V4L2_STD_PAL;
 	init_irqreg(btv);
-	v4l2_ctrl_handler_setup(hdl);
+	if (!bttv_tvcards[btv->c.type].no_video)
+		v4l2_ctrl_handler_setup(hdl);
 	if (hdl->error) {
 		result = hdl->error;
 		goto fail2;
-- 
1.8.3.2

