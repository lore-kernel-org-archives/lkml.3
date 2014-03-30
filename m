Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaC3Xso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:48:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784AbaC3Xnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ian Abbott" <abbotti@mev.co.uk>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.326070704@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 177/200] staging: comedi: ssv_dnp: correct insn_bits
 result
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

[Part of commit f6b316bcd8c421acd6fa5a6e18b4c846ecb9d965 upstream.
Split from original patch subject: "staging: comedi: ssv_dnp: use
comedi_dio_update_state()"]

Also, fix a bug where the state of the channels is returned in data[0].
The comedi core expects it to be returned in data[1].

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/ssv_dnp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -251,11 +251,11 @@ static int dnp_dio_insn_bits(struct come
 
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
 
 	return 2;
 

