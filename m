Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaAMRMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:12:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52795 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaAMQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/208] staging: comedi: ssv_dnp: use comedi_dio_update_state()
Date: Mon, 13 Jan 2014 15:57:26 +0000
Message-Id: <1389628849-1614-6-git-send-email-luis.henriques@canonical.com>
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

commit f6b316bcd8c421acd6fa5a6e18b4c846ecb9d965 upstream.

Use comedi_dio_update_state() to handle the boilerplate code to update
the subdevice s->state.

Also, fix a bug where the state of the channels is returned in data[0].
The comedi core expects it to be returned in data[1].

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
[ Ian: Applies to all stable kernels from 2.6.32.y to 3.12.y ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/ssv_dnp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 45c661c..1e34421 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -82,11 +82,11 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 
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

