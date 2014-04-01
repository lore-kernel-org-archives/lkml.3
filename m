Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaDABta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:49:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37971 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaDABt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:49:28 -0400
X-AuditID: cbfee690-b7f266d00000287c-44-533a1b27fbe1
Date: Tue, 01 Apr 2014 01:49:27 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] mtd: fsl_ifc_nand: Recover corrupted empty page for preventing
 read-only mount in UBIFS
To: computersforpeace@gmail.com, artem.bityutskiy@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140401014523235@eunb.song
Msgkey: 20140401014523235@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140401014523235@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <26017351.61791396316965998.JavaMail.weblogic@epv6ml06>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsVy+t8zHV11aatgg4dPhCwu75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJm/Pv7halgjmTFl+uz2RsYj0h0MXJyCAmoSLT8/84IYksImEjMmLmV
	FcIWk7hwbz1bFyMXUM0yRolv92YBFXGAFU39FAXRO59RYl4/mM0CNGfK1UVgc9gEtCV+HLjK
	DGILC2RIzJy9iA3EFhHwlZjxt5UVZAyzgLfEox4xiDHyEpNPX2YHsXkFBCVOznzCAnGCksTp
	xkdsEHFlianzu6FOk5CYNf0ClM0rMaP9KVS9nMS0r2uYIWxpifOzNjDCvLL4+2OoOL/Esds7
	mCA+4ZV4cj8YZszuzV/YIGwBialnDkK1qkvseDKdHcLmk1iz8C3UKkGJ09e6mWF672+ZywRi
	MwsoSkzpfsgOYWtJfPmxjw3dW7wCzhIHPj9jm8CoPAtJahaS9llI2pHVLGBkWcUomlqQXFCc
	lF5kghzVmxghKXDCDsZ7B6wPMe5nBEbJRGYp0eR8YBLNK4k3NDYzsjA1MTU2Mrc0o1DYxNTC
	wsSIKsJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAKWS+56TWtc07xAq6fR7zM
	Uv3/e0ntynlXNqe3V6xh6eKa5De7S5z11uyq93m7ftqkd8vueEoZt8y5usPoicvViu0/Gorr
	s9ddjFkVJLp94zXNs2ufHpqsfc5d5IPfuunr5XYo8hrulvkxk9kjPKfys5N2uHvDpxD7uqyr
	8xoOLSjI3piw2M1AiaU4I9FQi7moOBEAyEAeY/QDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tmbrq0lbBBvvn8llc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jH9/vzAVzJGs+HJ9NnsD4xGJLkZODiEBFYmW/98Zuxg5OCQETCSmfooCCUsIiElcuLeeDaJk
	PqPEvH6wOAtQ+ZSrixhBbDYBbYkfB64yg9jCAhkSM2cvAqsXEfCVmPG3lRVkJLOAt8SjHjGI
	MfISk09fZgexeQUEJU7OfMICsUpJ4nTjIzaIuLLE1PndrBBxCYlZ0y9A2bwSM9qfQtXLSUz7
	uoYZwpaWOD9rAyPMyYu/P4aK80scu72DCeIrXokn94Nhxuze/IUNwhaQmHrmIFSrusSOJ9PZ
	IWw+iTUL30KtEpQ4fa2bGab3/pa5TCA2s4CixJTuh+wQtpbElx/72NC9xSvgLHHg8zO2CYxy
	s5CkZiFpn4WkHVnNAkaWVYyiqQXJBcVJ6RXGesWJucWleel6yfm5mxjByenZ4h2M/89bH2IU
	4GBU4uG1KLcMFmJNLCuuzD3EKMHBrCTCe+Q9UIg3JbGyKrUoP76oNCe1+BBjMjD+JjJLiSbn
	AxNnXkm8obGBsaGhpbmBqaGRBWnCSuK88beSgoQE0hNLUrNTUwtSi2C2MHFwSjUwaq+4/sXp
	uezNNcemmLD+YbQyuypxWjc+/uyhzd/YfTc+e2yeqNHKPJdLsNWOc1L8eZlDvgo9KflTPZf8
	TQxLYL4Tyzy9nD+AQejGYlEp2dKS9wtnbpPX/iyi2VxoHDJX8E/Mb8VlN01a0peln7TY2x6h
	zcH1xXfuJoe1+e5/tFsWfT5g0xCnxFKckWioxVxUnAgAYibo55IDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s311nej9031337

Even if the meaning of EUCLEAN was changed by commit edbc4540.
There is still possibility of read-only mount in UBIFS with ubifs_scan() "corrupt empty space at LEB".
So i made this patch for fix that problem.
This patch do as follow.
 - If there are ecc errors which is equal to or less than chip->ecc.strength in page.
 - Check that page has how many zero bits, and if zero bits are equal to or less than
   chip->ecc.strength then overwrite 1 to zero bits in buf.

ubifs_scan() cannot detect corrupted empty space because buf is recovered by this patch.
And this is safe because ecc controller can correct up to chip->ecc.strength bits.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 drivers/mtd/nand/fsl_ifc_nand.c |   41 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 90ca7e7..2129c39 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -277,6 +277,42 @@ static int is_blank(struct mtd_info *mtd, unsigned int bufnum)
 	return 1;
 }
 
+static int num_zero_bits(uint8_t val)
+{
+	int i, ret=0;
+
+	for(i=7; i>=0 ; i--)
+		if(!(0x1 & (val >> i)))
+			ret++;
+
+	return ret;
+}
+
+static int is_corrupted_blank(struct mtd_info *mtd, uint8_t * buf)
+{
+	struct nand_chip *chip = mtd->priv;
+	int i;
+	int zero_bits = 0;
+
+	for (i = 0; i < mtd->writesize ; i++) {
+		if(buf[i] != 0xff) {
+			zero_bits += num_zero_bits(buf[i]);	
+		}
+	}
+
+	if(zero_bits && (zero_bits <= chip->ecc.strength)){
+		return 1;
+	}
+
+	return 0;
+}
+
+static void recover_corrupted_blank(struct mtd_info *mtd, uint8_t * buf)
+{
+	memset(buf, 0xff, mtd->writesize);
+	return;
+}
+
 /* returns nonzero if entire page is blank */
 static int check_read_ecc(struct mtd_info *mtd, struct fsl_ifc_ctrl *ctrl,
 			  u32 *eccstat, unsigned int bufnum)
@@ -760,6 +796,11 @@ static int fsl_ifc_read_page(struct mtd_info *mtd, struct nand_chip *chip,
 	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC)
 		mtd->ecc_stats.failed++;
 
+	if(nctrl->max_bitflips && (nctrl->max_bitflips <= chip->ecc.strength)){
+		if(is_corrupted_blank(mtd, buf))
+			recover_corrupted_blank(mtd, buf);
+	}
+
 	return nctrl->max_bitflips;
 }
 
-- 
1.7.0.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
