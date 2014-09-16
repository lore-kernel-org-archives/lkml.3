Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaIPIwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:52:19 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46615 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaIPIwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:52:13 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-98-5417fa392a25
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 2/4] amba: Add helper macros for (un)preparing AMBA clock
Date: Tue, 16 Sep 2014 10:51:32 +0200
Message-id: <1410857494-15936-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
References: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xy7qWv8RDDFZcMrLYOGM9q8X0qRcY
	LVZP/ctqceDPDkaL1y8MLc42vWG3WDJ5PqvFrCl7mSwWti1hsbi8aw6bxefeI4wWty/zWqw9
	cpfd4t3LCIu7p46yWby9M53F4szpS6wWE35fYLM4vjbc4mXffhYHEY+W5h42j80rtDwW73nJ
	5HHn2h42jyVvDrF6bLnazuIx++4PRo++LasYPVas/s7u8XmTnMfez79ZArijuGxSUnMyy1KL
	9O0SuDL2Hj7IUnCAveLSw5dMDYxr2LoYOTkkBEwknh++zgxhi0lcuLceLC4ksJRR4uJX2y5G
	LiC7j0li2vuDrCAJNgFjic3Ll7CBJEQEjrBIPLv3BMxhFjjKKDG99y0TSJWwgI/E8+kzwUax
	CKhKXGh8A7aCV8BdYu20jVDr5CROHpsMNpVTwENi0tzr7BCr3SUO7L3DPoGRdwEjwypG0dTS
	5ILipPRcI73ixNzi0rx0veT83E2MkGj4uoNx6TGrQ4wCHIxKPLwzNoqFCLEmlhVX5h5ilOBg
	VhLhffBJPESINyWxsiq1KD++qDQntfgQIxMHp1QDY83SiSdiStySXz5btISjXbj4riwXJ5vR
	XF+m3r4DX09XRS1NU1gdtWNW/AS9/0dvaTkfaAnRW3PdLuJ4cuPN3S4enzVyTfyNvr5W31dU
	OsHr9pJgRxnnCcr7bbxnTkua9SD9YNfhM7UlKnLF0efO82t93DP/SET2JjbeyxdvZL/8PvvX
	5qeZi5VYijMSDbWYi4oTAXwy+e1kAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add amba_pclk_prepare() and amba_pclk_unprepare() macros for handling
the AMBA bus clock by device drivers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/amba/bus.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index fdd7e1b61f60..ad52027a9cbf 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -92,6 +92,12 @@ void amba_release_regions(struct amba_device *);
 #define amba_pclk_disable(d)	\
 	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
 
+#define amba_pclk_prepare(d)	\
+	(IS_ERR((d)->pclk) ? 0 : clk_prepare((d)->pclk))
+
+#define amba_pclk_unprepare(d)	\
+	do { if (!IS_ERR((d)->pclk)) clk_unprepare((d)->pclk); } while (0)
+
 /* Some drivers don't use the struct amba_device */
 #define AMBA_CONFIG_BITS(a) (((a) >> 24) & 0xff)
 #define AMBA_REV_BITS(a) (((a) >> 20) & 0x0f)
-- 
1.9.1

