Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbaAaRfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:35:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbaAaRcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:32:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 13/14] staging: comedi: addi_apci_1032: fix subdevice type/flags bug
Date: Fri, 31 Jan 2014 09:32:16 -0800
Message-Id: <1391189537-20777-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391189537-20777-1-git-send-email-kamal@canonical.com>
References: <1391189537-20777-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit 90daf69a7a3f1d1a41018c799968a0bb896d65e0 upstream

The SDF_CMD_READ should be one of the s->subdev_flags not part of
the s->type.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/comedi/drivers/addi_apci_1032.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1032.c b/drivers/staging/comedi/drivers/addi_apci_1032.c
index 7f94242..97de74e 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1032.c
@@ -331,8 +331,8 @@ static int apci1032_auto_attach(struct comedi_device *dev,
 	s = &dev->subdevices[1];
 	if (dev->irq) {
 		dev->read_subdev = s;
-		s->type		= COMEDI_SUBD_DI | SDF_CMD_READ;
-		s->subdev_flags	= SDF_READABLE;
+		s->type		= COMEDI_SUBD_DI;
+		s->subdev_flags	= SDF_READABLE | SDF_CMD_READ;
 		s->n_chan	= 1;
 		s->maxdata	= 1;
 		s->range_table	= &range_digital;
-- 
1.8.3.2

