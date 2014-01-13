Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaAMRMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:12:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaAMQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 006/208] staging: comedi: drivers: use comedi_dio_update_state() for simple cases
Date: Mon, 13 Jan 2014 15:57:27 +0000
Message-Id: <1389628849-1614-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 97f4289ad08cffe55de06d4ac4f89ac540450aee upstream.

[Split from original patch subject: "staging: comedi: drivers: use
comedi_dio_update_state() for simple cases"]

Also, fix a bug in the amplc_pc263 and amplc_pci263 drivers where the
current state is not returned in data[1].

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
[Ian: Applies to 3.10.y, 3.11.y and 3.12.y ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/amplc_pc263.c  | 3 +++
 drivers/staging/comedi/drivers/amplc_pci263.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 6546095..f16c3f8 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -67,6 +67,9 @@ static int pc263_do_insn_bits(struct comedi_device *dev,
 		outb(s->state & 0xFF, dev->iobase);
 		outb(s->state >> 8, dev->iobase + 1);
 	}
+
+	data[1] = s->state;
+
 	return insn->n;
 }
 
diff --git a/drivers/staging/comedi/drivers/amplc_pci263.c b/drivers/staging/comedi/drivers/amplc_pci263.c
index 4da900c..fe6aa5f 100644
--- a/drivers/staging/comedi/drivers/amplc_pci263.c
+++ b/drivers/staging/comedi/drivers/amplc_pci263.c
@@ -54,6 +54,9 @@ static int pci263_do_insn_bits(struct comedi_device *dev,
 		outb(s->state & 0xFF, dev->iobase);
 		outb(s->state >> 8, dev->iobase + 1);
 	}
+
+	data[1] = s->state;
+
 	return insn->n;
 }
 
-- 
1.8.3.2

