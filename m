Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaJTJFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:05:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47572 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaJTJF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:05:26 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-24-5444d0505900
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v8 2/5] amba: Add helpers for (un)preparing AMBA clock
Date: Mon, 20 Oct 2014 11:04:45 +0200
Message-id: <1413795888-18559-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xa7oBF1xCDO4tk7TYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLM6cvsRqMeH3BTaL42vDLV727WdxEPZoae5h81i85yWTx51re4Csvsms
	HkveHGL12HK1ncVj9t0fjB59W1YxeqxY/Z3d4/MmOY+9n3+zBHBHcdmkpOZklqUW6dslcGXc
	ut3CVPCIveLm4SPMDYwn2boYOTkkBEwk5vZ8h7LFJC7cWw9kc3EICSxllJj7ZjMThNPHJLHw
	ThtYFZuAscTm5UvAqkQEjrNILO65AOYwC0xhlGietJQJpEpYwE3i6fWj7CA2i4CqxP4JM4Fs
	Dg5eAXeJu99lINbJSZw8NpkVxOYU8JCY3vKYEcQWAirpXriKaQIj7wJGhlWMoqmlyQXFSem5
	hnrFibnFpXnpesn5uZsYIVHwZQfj4mNWhxgFOBiVeHgFLF1ChFgTy4orcw8xSnAwK4nwMh0F
	CvGmJFZWpRblxxeV5qQWH2Jk4uCUamCcIOneeJ+78YXdjTWCB7nMNtbzaP+40F+x8iCv0J/Z
	tgc2cXUu7ZV/MPEEz1TPk7mHa4VmsC95+GH2domi/Ce1X217JquGnnESWPMiZtuusLMCa8Vr
	300KnReVL1fwbV9prtfpg+4XSsTsJ9zdkOqrvCMulqt727LKqEt2m3/tnrV8y8nWpLsblFiK
	MxINtZiLihMBFvqTX2ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add amba_pclk_prepare() and amba_pclk_unprepare() inline functions for
handling the AMBA bus clock by device drivers.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
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

