Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbaH0Gyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:54:40 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:39491 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbaH0Gyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:54:39 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 02:54:38 EDT
X-Yandex-Uniq: e99511f9-328d-43e9-914d-cb4aabbab183
Authentication-Results: smtp17.mail.yandex.net; dkim=pass header.i=@ya.ru
From: naszar <naszar@ya.ru>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Vladimir A. Nazarenko" <naszar@ya.ru>
Subject: [PATCH] Staging: comedi: Fix code style in jr3_pci.c
Date: Wed, 27 Aug 2014 17:48:21 +1100
Message-Id: <1409122101-6710-1-git-send-email-naszar@ya.ru>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir A. Nazarenko <naszar@ya.ru>

Static variables are initialised to 0 by GCC.
Fixes checkpatch.pl error:
  ERROR: do not initialise statics to 0 or NULL
  #684: FILE: jr3_pci.c:684:
  +	static const struct jr3_pci_board *board = NULL;

Signed-off-by: Vladimir A. Nazarenko <naszar@ya.ru>
---
 drivers/staging/comedi/drivers/jr3_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 7b20e19..81fab2d 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -681,7 +681,7 @@ static int jr3_pci_auto_attach(struct comedi_device *dev,
 			       unsigned long context)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-	static const struct jr3_pci_board *board = NULL;
+	static const struct jr3_pci_board *board;
 	struct jr3_pci_dev_private *devpriv;
 	struct jr3_pci_subdev_private *spriv;
 	struct comedi_subdevice *s;
-- 
2.1.0

