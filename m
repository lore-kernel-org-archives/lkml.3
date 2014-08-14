Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaHNAV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:21:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34764 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaHNAVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:21:25 -0400
X-AuditID: cbfee691-b7f306d000003d81-e1-53ec00ef5bf7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 2/4] extcon: sm5502: Fix bug to check cable type
Date: Thu, 14 Aug 2014 09:20:58 +0900
Message-id: <1407975660-3993-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407975660-3993-1-git-send-email-cw00.choi@samsung.com>
References: <1407975660-3993-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWyRsSkUPc9w5tgg6XHhSyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6MZ9dXsBfsYqt4/HwHSwPj
	ZtYuRk4OCQETic/NrWwQtpjEhXvrgWwuDiGBpYwSez4/Y4cp6nv/jBEiMZ1R4u3MaywQThOT
	RPuqvUwgVWwCWhL7X9wAGyUioCCxufcZ2ApmgXiJs93djCC2sICTxMFVv8FqWARUJRYfXw4U
	5+DgFXCR6N9WCLFMTuLDnkdgizkFXCWmnvjEDGILAZU8XzEX7DoJgfdsEh/2zmWCmCMg8W3y
	IRaQORICshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQJD
	9fS/ZxN3MN4/YH2IMRlo3ERmKdHkfGCo55XEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QD4zHDC9f/nxbzV0j4cvfU1P+/jgXmrr+x5ug9m+//WP4V
	324JKClsF+raLTDx4aX9t9du7Zy4rSlHIlz1Mfdhlq1BRq7TC6Q+SbCtF0ljOzs91NHW3epq
	r8qDsuele9vXxCevkTqaX2vzJl/D3aFMtFTkdAZ3nGLLdOX3yYcy61hWta26WPBIVYmlOCPR
	UIu5qDgRAPVv0NFrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoO57hjfBBmdvcVtc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGc+ur2Av2MVW8fj5DpYGxs2sXYycHBICJhJ9758xQthiEhfurWfrYuTiEBKYzijx
	duY1FginiUmifdVeJpAqNgEtif0vbrCB2CICChKbe5+BTWIWiJc4290NNklYwEni4KrfYDUs
	AqoSi48vB4pzcPAKuEj0byuEWCYn8WHPI3YQm1PAVWLqiU/MILYQUMnzFXPZJjDyLmBkWMUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHAnPpHcwrmqwOMQowMGoxMPrEfU6WIg1say4MvcQ
	owQHs5IIr99uoBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbnA6M0ryTe0NjEzMjSyNzQwsjY
	XEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QDo4nZvPdfU/eUzvoo4HXLaLPc0vpVt8LjeWzj
	7oo8/ixyM+fEzm8b7MW5Qq9uf/tczNZyRvDHaQp5N2YpV7nttvFfsT1ryw6GtWzKs443L4le
	P71wDodr6A3//aVxWq8KTCILrr0QLT+b+c350fcj52b6iO18/slaUEGUvafjzVmDb8s3dE8p
	eanEUpyRaKjFXFScCABgBhUumgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug when checking cable type. SM5502 have to use ADC value
to get correct cable type.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-sm5502.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
index aab630e..f94d66a 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -296,7 +296,7 @@ static unsigned int sm5502_muic_get_cable_type(struct sm5502_muic_info *info)
 	 * If ADC is SM5502_MUIC_ADC_GROUND(0x0), external cable hasn't
 	 * connected with to MUIC device.
 	 */
-	cable_type &= SM5502_REG_ADC_MASK;
+	cable_type = adc & SM5502_REG_ADC_MASK;
 	if (cable_type == SM5502_MUIC_ADC_GROUND)
 		return SM5502_MUIC_ADC_GROUND;
 
-- 
1.8.0

