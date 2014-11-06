Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKFIhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:37:15 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27067 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaKFIhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:37:03 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-8a-545b332cbd08
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v10 2/5] amba: Add helpers for (un)preparing AMBA clock
Date: Thu, 06 Nov 2014 09:36:47 +0100
Message-id: <1415263010-7992-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
References: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xK7o6xtEhBid+6lhsnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbLJk8n9Wic+ISdotZU/YyWVzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLM6cvsRqMeH3BTaL42vDLV727WdxEPZoae5h85jdMZPVY/Gel0wem1Z1
	snncubaHzWPJm0OsHluutrN4zL77g9Gjb8sqRo8Vq7+ze3zeJOex9/NvlgCeKC6blNSczLLU
	In27BK6MO38vsxZM5aiY8E2vgfE7WxcjJ4eEgIlEw//DTBC2mMSFe+uB4lwcQgJLGSV+vVvO
	CuH0MUl8P7AerINNwFhi8/IlYFUiAteZJbof97OAJJgFFjFJNE1VBLGFBdwlDmzbxg5iswio
	SkxZv5MRxOYVcJOY2D2NEWKdnMTJY5NZQWxOoPpfSz6AnSEEVNP+dTb7BEbeBYwMqxhFU0uT
	C4qT0nON9IoTc4tL89L1kvNzNzFCouHrDsalx6wOMQpwMCrx8EawR4cIsSaWFVfmHmKU4GBW
	EuGN0AMK8aYkVlalFuXHF5XmpBYfYmTi4JRqYDx9LOuu1B3X7vtt7b8WzZPcdE1sVszhgLcn
	jk550Hpe4emDdzeu6eYc1m3h5F3hWvlJlvt18cn3qV9MEnKNTGfk5scW97qe3zP/8Pnjad2V
	lfMc33/55Fvzjf3xgZjN8q87LZ6+DHn7f5GN7673z6R0upW0D82RrLszaeWe/QxnrE89sju1
	+uI2JZbijERDLeai4kQACtoOpWQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add amba_pclk_prepare() and amba_pclk_unprepare() inline functions for
handling the AMBA bus clock by device drivers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 include/linux/amba/bus.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index c324f5700d1a..ac02f9bd63dc 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -97,6 +97,16 @@ void amba_release_regions(struct amba_device *);
 #define amba_pclk_disable(d)	\
 	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
 
+static inline int amba_pclk_prepare(struct amba_device *dev)
+{
+	return clk_prepare(dev->pclk);
+}
+
+static inline void amba_pclk_unprepare(struct amba_device *dev)
+{
+	clk_unprepare(dev->pclk);
+}
+
 /* Some drivers don't use the struct amba_device */
 #define AMBA_CONFIG_BITS(a) (((a) >> 24) & 0xff)
 #define AMBA_REV_BITS(a) (((a) >> 20) & 0x0f)
-- 
1.9.1

