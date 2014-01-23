Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaAWSjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:39:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaAWSjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:39:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.10 06/23] staging: comedi: addi_apci_1032: fix subdevice type/flags bug
Date: Thu, 23 Jan 2014 10:39:39 -0800
Message-Id: <20140123183900.671021050@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123183859.635713053@linuxfoundation.org>
References: <20140123183859.635713053@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit 90daf69a7a3f1d1a41018c799968a0bb896d65e0 upstream.

The SDF_CMD_READ should be one of the s->subdev_flags not part of
the s->type.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/addi_apci_1032.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/drivers/addi_apci_1032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1032.c
@@ -332,8 +332,8 @@ static int apci1032_auto_attach(struct c
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


