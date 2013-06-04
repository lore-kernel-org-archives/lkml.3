Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3FDWrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:47:53 -0400
Received: from 1wt.eu ([62.212.114.60]:35913 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab3FDWod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:33 -0400
Message-Id: <20130604172133.290348586@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 072/184] staging: comedi: jr3_pci: fix iomem dereference
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit e1878957b4676a17cf398f7f5723b365e9a2ca48 upstream.

Correct a direct dereference of I/O memory to use an appropriate I/O
memory access function.  Note that the pointer being dereferenced is not
currently tagged with `__iomem` but I plan to correct that for 3.7.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/drivers/jr3_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 1d6385a..ae6f40c 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -917,7 +917,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	}
 
 	/*  Reset DSP card */
-	devpriv->iobase->channel[0].reset = 0;
+	writel(0, &devpriv->iobase->channel[0].reset);
 
 	result = comedi_load_firmware(dev, "jr3pci.idm", jr3_download_firmware);
 	printk("Firmare load %d\n", result);
-- 
1.7.12.2.21.g234cd45.dirty



