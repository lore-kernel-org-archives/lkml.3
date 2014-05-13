Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbaEMLDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:03:32 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58814 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760437AbaEMK7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:03 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-63-5371faf44848
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 07/16] mfd: rtsx_usb: Make mfd_cell array const
Date: Tue, 13 May 2014 12:58:44 +0200
Message-id: <1399978733-13662-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t/xy7pffhUGG3y8pGDx+oWhxf2vRxkt
	Lu+aw2Zx++dMdovT3awOrB53ru1h85h3MtDj8dvN7B59W1YxenzeJBfAGsVlk5Kak1mWWqRv
	l8CVMXPjBqaCPraKf3OWsTYw9rN2MXJySAiYSLyevIEdwhaTuHBvPVsXIxeHkMBSRokFH89D
	OX1MEtv2HwfrYBMwlti8fAkbiC0ikCXxY9pqFhCbWSBC4lfvTzBbWMBeYtuWLWA1LAKqEtf2
	HQXr5RVwlzjw4RYLxDY5iZPHJoPFOQU8JF7cPgtmCwHV3Fg1iWUCI+8CRoZVjKKppckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGCHB83UH49JjVocYBTgYlXh4PZgLgoVYE8uKK3MPMUpwMCuJ8Lp/
	KgwW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMhexdxf9+LGvPUqZ+vZO/NDvHIPrMi7HKfwUj+5
	cI2AW1Pir7xt85rstyf4zstpTHlb+uyMUWNyglhhwLdFa986smcpu11n+9OmGZxYNu//b6kd
	ciXGXa3zbOMyExTf2fQme6m89LfWtpt4lWPG6oMmnrcb3v79tS5Rlk+37ozcc4WQI10/lViK
	MxINtZiLihMBlhSxdvwBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd_add_devices() expects array of struct mfd_cell to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Roger Tseng <rogerable@realtek.com>
---
 drivers/mfd/rtsx_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 141ea52c46e3..6352bec8419a 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -29,7 +29,7 @@ static int polling_pipe = 1;
 module_param(polling_pipe, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(polling_pipe, "polling pipe (0: ctl, 1: bulk)");
 
-static struct mfd_cell rtsx_usb_cells[] = {
+static const struct mfd_cell rtsx_usb_cells[] = {
 	[RTSX_USB_SD_CARD] = {
 		.name = "rtsx_usb_sdmmc",
 		.pdata_size = 0,
-- 
1.9.1

