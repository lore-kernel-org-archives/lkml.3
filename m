Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaCNFFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:05:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10316 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaCNFFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:05:01 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-dc-53228dfcdcda
Date: Fri, 14 Mar 2014 14:05:00 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 07/27] iommu/exynos: always enable runtime PM
Message-id: <20140314140500.d854a6a8fed6ec7c0886a44b@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zI90/vUrBBvemK1ncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJVx7e4FtoJD7BWfOxcwNTAuZuti5OSQEDCR+HVsOjOE
	LSZx4d56sLiQwDJGiSevHWFqVi19zdTFyAUUn84o0Tf3LguEM5lJonvTXLAOFgFViQNPG9lB
	bDYBLYnVc48zghSJCLQxSXxtPATWwSwwl1ni47c5YB3CAo4Sd9f+AOvgBbLf/2pjhNhnIXGh
	qQMqLijxY/I9FhCbGWjq5m1NrBC2vMTmNW+h7m7lkFg1iQPiCgGJb5NBlnEAxWUlNh2AKpGU
	OLjiBssERpFZSKbOQjJ1FpKpCxiZVzGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmKERG/vDsbb
	B6wPMSYDrZzILCWanA+M/rySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbF
	F5XmpBYfYmTi4JRqYLTamblw8ZTUtUG8+n2ibz6H7WY1WXxJtG7FDwXZSwqf3N7PUzl+qLFQ
	Sajps6v4m/q8D9a6rWa9F3I/vDsrcs+eW6CvM1drZ55Ej8XXzyfLpTbvN3zXXtQ7ffe6c7Gz
	v/L9zevUc78pxpS4NFFnsqaotL72osn93yVmftxlLc7+eouG/T53PSWW4oxEQy3mouJEAF/5
	Ujz0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQd0/vUrBBv8fyVjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49rdC2wFh9gr
	PncuYGpgXMzWxcjJISFgIrFq6WsmCFtM4sK99UBxLg4hgemMEn1z77JAOJOZJLo3zQXrYBFQ
	lTjwtJEdxGYT0JJYPfc4I0iRiEAbk8TXxkNgHcwCc5klPn6bA9YhLOAocXftD7AOXiD7/a82
	Roh9FhIXmjqg4oISPybfYwGxmYGmbt7WxAphy0tsXvOWeQIj3ywkZbOQlM1CUraAkXkVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnB6eCa1g3Flg8UhRgEORiUeXofDisFCrIllxZW5hxgl
	OJiVRHirIpSChXhTEiurUovy44tKc1KLDzEmA/09kVlKNDkfmLrySuINjU3MjCyNzCyMTMzN
	SRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoEx5Lb4g08L1GRn3O9NvnL/21FOFTb527uP
	7c1g745tf/Lpt4yZfGrkioNzdxrNUJ67ljMt5JZ0zlR3syk37vJUr2Zet//OjLd1B3jOcLQf
	ZHp3au8d7sPCwl0cD5ymbdo5Z4mb6tPTIvmXBC5e8jGvmr7WSGlPkN4DvdANExjNXZLWbFhm
	GndimxJLcUaioRZzUXEiAB68E3xTAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking if the probing device has a parent device was just to discover
if the probing device is involved in a power domain when the power
domain controlled by Samsung's custom implementation.
Since generic IO power domain is applied, it is required to remove
the condition to see if the probing device has a parent device.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index bee1bb1..8dc7031 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -632,8 +632,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	__set_fault_handler(data, &default_fault_handler);
 
-	if (dev->parent)
-		pm_runtime_enable(dev);
+	pm_runtime_enable(dev);
 
 	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
 	return 0;
-- 
1.7.9.5

