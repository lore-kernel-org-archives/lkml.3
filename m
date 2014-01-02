Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaABRQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:16:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40512 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbaABRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 53/91] staging: comedi: ssv_dnp: use comedi_dio_update_state()
Date: Thu,  2 Jan 2014 09:04:28 -0800
Message-Id: <1388682306-30859-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit f6b316bcd8c421acd6fa5a6e18b4c846ecb9d965 upstream.

Use comedi_dio_update_state() to handle the boilerplate code to update
the subdevice s->state.

Also, fix a bug where the state of the channels is returned in data[0].
The comedi core expects it to be returned in data[1].

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
[ Ian: Applies to all stable kernels from 2.6.32.y to 3.12.y ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/comedi/drivers/ssv_dnp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index afa4016..217d5b6 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -87,11 +87,11 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 
 	/* on return, data[1] contains the value of the digital input lines. */
 	outb(PADR, CSCIR);
-	data[0] = inb(CSCDR);
+	data[1] = inb(CSCDR);
 	outb(PBDR, CSCIR);
-	data[0] += inb(CSCDR) << 8;
+	data[1] += inb(CSCDR) << 8;
 	outb(PCDR, CSCIR);
-	data[0] += ((inb(CSCDR) & 0xF0) << 12);
+	data[1] += ((inb(CSCDR) & 0xF0) << 12);
 
 	return insn->n;
 
-- 
1.8.3.2

