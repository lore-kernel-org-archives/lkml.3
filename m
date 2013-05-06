Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3EFEdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:33:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46378 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3EFEdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:33:24 -0400
X-AuditID: cbfee690-b7f136d000000fea-fd-518732928085
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Seungwon Jeon'" <tgih.jun@samsung.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] mmc: dw_mmc: fix fifo access for 64-bit
Date: Mon, 06 May 2013 13:33:22 +0900
Message-id: <000f01ce4a12$d77ccc30$86766490$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ91JRu2BBtua9S22v97IZnHjVxur
	xZJmbovLu+awWSzY+IjR4sP9i8wObB6Hrqxl9OjbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
	XdvuMBbc4qg4Nj2+gXEuexcjJ4eEgInE1+WH2SBsMYkL99aD2UICyxgl1pwMhKk5cv40cxcj
	F1B8OqPEjjV7mCCcv4wS7e83gXWwCehKHFu/hRXEFhHwljg15RdYB7NAL6PE7WfdQB0cQB3c
	Equbg0BqOAV4JNb96WQGsYUFnCX27p0BdhGLgKrE/NUnwObwCthJ3Fg8gxHCFpT4MfkeC4jN
	LKAlsX7ncSYIW15i85q3zCDjJQTUJR791YU4IULi0+arUCUiEvtevGMEOUdC4Bq7RNOVzVC7
	BCS+TT7EAtErK7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ
	6BUn5haX5qXrJefnbmKExOaEHYz3DlgfYkwGWj+RWUo0OR8Y23kl8YbGZkYWpiamxkbmlmak
	CSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYCy/Mn2b1aI1Rf3ZXz+v10p/ZvlC
	esZG4aJ3foc+b2FQ3T2r5mWq/KQXxp/ijqaz/gxdkcBZWaYqfTbHdUri58obXK3l8fJZqil7
	hO/99m3SeHGkiTF2petl5pNq7Zv36nrvd9iT9z41r0tn0lf9k21svZoL3vI1T0pNYWA9Xmeh
	5um8J/RnpBJLcUaioRZzUXEiAF0157vjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd1JRu2BBsueaFlsf72RzeLGrzZW
	iyXN3BaXd81hs1iw8RGjxYf7F5kd2DwOXVnL6NG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGbu23WEsuMVRcWx6fAPjXPYuRk4OCQETiSPnTzND2GIS
	F+6tZ+ti5OIQEpjOKLFjzR4mCOcvo0T7+01sIFVsAroSx9ZvYQWxRQS8JU5N+cUMUsQs0Mso
	cftZN1AHB1AHt8Tq5iCQGk4BHol1fzrBNggLOEvs3TsDbDOLgKrE/NUnwObwCthJ3Fg8gxHC
	FpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCDjJQTUJR791YU4IULi0+arUCUiEvtevGOcwCg0
	C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmP/mdQOxpUNFocY
	BTgYlXh4C560BQqxJpYVV+YeYpTgYFYS4fXZCxTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHk
	fGBayiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRqbvv+Iz
	NR/E/54wJed2RxBfy2rWC9/ecq/uPHK2USSiPOmlE3t71qHXzDp2tcuqmxU/htv9UNI/8T/E
	avsH04XvVSKnfi2ycM51LJ26dGu0f9HulZctvwrpXDoo7b/01Fe1t+cvr5C9XZPxV3iS7Ltz
	37QYH228dM//cFSxi67p703XrRblpCmxFGckGmoxFxUnAgD68IzrQQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Seungwon Jeon <tgih.jun@samsung.com>"

commit c09fbd7451b797213b3df8bf077776b9ec33f954 upstream

mci_writew causes a failure of fifo access for 64-bit.
mci_writeq is correct.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/mmc/host/dw_mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 9834221..cc8d8de 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1353,7 +1353,7 @@ static void dw_mci_push_data64(struct dw_mci *host,
void *buf, int cnt)
 		buf += len;
 		cnt -= len;
 		if (!sg_next(host->sg) || host->part_buf_count == 8) {
-			mci_writew(host, DATA(host->data_offset),
+			mci_writeq(host, DATA(host->data_offset),
 					host->part_buf);
 			host->part_buf_count = 0;
 		}
-- 
1.7.9.5

