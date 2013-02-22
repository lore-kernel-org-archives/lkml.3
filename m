Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3BVIEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:04:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13740 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3BVIES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:04:18 -0500
X-AuditID: cbfee691-b7f556d000001a24-67-5127267fd99d
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, alsa-devel@alsa-project.org
Cc: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>,
        "'Boojin Kim'" <boojin.kim@samsung.com>
Subject: [PATCH v2 1/4] DMA: pl330: support burst mode for dev-to-mem and
 mem-to-dev transmit
Date: Fri, 22 Feb 2013 17:04:15 +0900
Message-id: <000001ce10d3$354dd440$9fe97cc0$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q0zRNgYHsZtryQK2Zcgnt7X5e4w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t8zY916NfVAgwkbFS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLefDrMWNDJX7F99wf2Bsa1PF2MnBwSAiYSrxa/ZYWw
	xSQu3FvP1sXIxSEksIxR4k1HAytM0ZOJZ1khEtMZJWbencgE4fxllFi6ZBs7SBWbgKbEjO/T
	wWwRgc2MEpNfZ4EUMQt8YZLou30VLCEsEC8xrW8tmM0ioCrxr+EiE4jNK2ArsWHvc5YuRg6g
	deoSj/7qQszRk1i2YiULiM0sICKx78U7RpCZEgKP2SQeLZ3PDDFHQOLb5ENQvbISmw4wQ1wt
	KXFwxQ2WCYzCs5C0L2BkXMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kREqYTdzDeP2B9iDEZ
	aPREZinR5HxgmOeVxBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA6PHieMPuDldouq9TDW2T1Nnl0z4suDO5eq2Yzk75Mz+sjPZ9pnPMxNXsu7Qj95e
	/Hr/cqauFXYlvlv44rYY5cze8+/I1O2B+/JLl37s+t0nN5u3vFR+sVSokqc7X2qH2YQnvHny
	rskBNm9Lq9uW5t1++WbN4uPFs12EgtccONJorh8pdOmPrBJLcUaioRZzUXEiAP/dflFpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQd16NfVAg0urZSwu75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz3nw6zFjQyV+x
	ffcH9gbGtTxdjJwcEgImEk8mnmWFsMUkLtxbz9bFyMUhJDCdUWLm3YlMEM5fRomlS7axg1Sx
	CWhKzPg+HcwWEdjMKDH5dRZIEbPAFyaJvttXwRLCAvES0/rWgtksAqoS/xouMoHYvAK2Ehv2
	PmfpYuQAWqcu8eivLsQcPYllK1aygNjMAiIS+168Y5zAyDsLibuAkXEVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnAUPJPawbiyweIQowAHoxIPb4OLWqAQa2JZcWXuIUYJDmYlEd5FCuqB
	QrwpiZVVqUX58UWlOanFhxiTgQ6cyCwlmpwPjNC8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0J
	EBJITyxJzU5NLUgtgtnCxMEp1cDotqLnk+3mhZG5MSETrFt4E1zXJZt+WZV07IBL84pPM72u
	+x2ymH3y9c68JzE8GU8f8QrlfJTf/LZ2RdH2SBvmGibB1VOuydee3LPy+rG1ep0Wme4u+4+n
	Tbx0kPnLz9NvJRrFeFYsTelkZgqoTtg+5xf/tgtO3ttOpx58f8zy6xbB0/syP3E4KrEUZyQa
	ajEXFScCAC0URQbGAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to support burst mode for dev-to-mem and mem-to-dev transmit

Change-Id: I9723e49383416773699cf7735168177c8d036f30
Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 drivers/dma/pl330.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 80680ee..c67f037 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1271,10 +1271,11 @@ static inline int _ldst_devtomem(unsigned dry_run, u8 buf[],
 		const struct _xfer_spec *pxs, int cyc)
 {
 	int off = 0;
+	enum pl330_cond cond = (pxs->r->cfg->brst_len == 1) ? SINGLE : BURST;

 	while (cyc--) {
-		off += _emit_WFP(dry_run, &buf[off], SINGLE, pxs->r->peri);
-		off += _emit_LDP(dry_run, &buf[off], SINGLE, pxs->r->peri);
+		off += _emit_WFP(dry_run, &buf[off], cond, pxs->r->peri);
+		off += _emit_LDP(dry_run, &buf[off], cond, pxs->r->peri);
 		off += _emit_ST(dry_run, &buf[off], ALWAYS);
 		off += _emit_FLUSHP(dry_run, &buf[off], pxs->r->peri);
 	}
@@ -1286,11 +1287,12 @@ static inline int _ldst_memtodev(unsigned dry_run, u8 buf[],
 		const struct _xfer_spec *pxs, int cyc)
 {
 	int off = 0;
+	enum pl330_cond cond = (pxs->r->cfg->brst_len == 1) ? SINGLE : BURST;

 	while (cyc--) {
-		off += _emit_WFP(dry_run, &buf[off], SINGLE, pxs->r->peri);
+		off += _emit_WFP(dry_run, &buf[off], cond, pxs->r->peri);
 		off += _emit_LD(dry_run, &buf[off], ALWAYS);
-		off += _emit_STP(dry_run, &buf[off], SINGLE, pxs->r->peri);
+		off += _emit_STP(dry_run, &buf[off], cond, pxs->r->peri);
 		off += _emit_FLUSHP(dry_run, &buf[off], pxs->r->peri);
 	}

@@ -2835,7 +2837,7 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		}

 		desc->rqcfg.brst_size = pch->burst_sz;
-		desc->rqcfg.brst_len = 1;
+		desc->rqcfg.brst_len = pch->burst_len;
 	}

 	/* Return the last desc in the chain */
--
1.7.5.4



