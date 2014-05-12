Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaELGVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:21:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35475 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaELGQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:40 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-77-537067478d00
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 07/19] iommu/exynos: always enable runtime PM
Date: Mon, 12 May 2014 11:44:52 +0530
Message-id: <1399875304-19948-8-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkTtc9vSDY4PAnXYs7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6MTysPMBbM5qg4d/0AewPje7YuRk4OCQETieaGRiYIW0ziwr31QHEuDiGB
	pYwSTw6dYYEpWvH3MQtEYhGjxMEvn8G6hQQmMEks+s8MYrMJGEpsv3eFFaRIRGA1o0TfxTPs
	IA6zwGxmiSOPFjOCVAkLOEqcmjSPHcRmEVCVuPj9NVg3r4C7xO77k4BWcACtU5CYM8kGJMwp
	4CHxefUUqGXuEsdeXQVbICGwlkPi6vsuFog5AhLfJh+C6pWV2HSAGeJqSYmDK26wTGAUXsDI
	sIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjMFpP/3s2YQfjvQPWhxiTgcZNZJYSTc4HRnte
	SbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCWmIrZ
	+Z+U/FKSGGPTZ/dcY+H8zaKZWfsyHhx2/L0qovz3myLz8IsvvRas1agNkzzOnaD3sO1YnoDp
	MZfHTc2MFqbPHMrD5N57Ptw662xqehXv15vPP67yf+ht66ztUm5jvPFQcWTom5vTKw5sfCjs
	//TxprIo9ckHp0VzP1XP3sf2+u3DOiklluKMREMt5qLiRAB3/4cp7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV339IJggwlTVCzu3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZnxaeYCxYDZHxbnrB9gbGN+zdTFy
	ckgImEis+PuYBcIWk7hwbz1QnItDSGARo8TBL5/BioQEJjBJLPrPDGKzCRhKbL93hRWkSERg
	NaNE38Uz7CAOs8BsZokjjxYzglQJCzhKnJo0jx3EZhFQlbj4/TVYN6+Au8Tu+5OA1nEArVOQ
	mDPJBiTMKeAh8Xn1FKhl7hLHXl1lncDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZG
	cCp4JrWDcWWDxSFGAQ5GJR7eDwwFwUKsiWXFlbmHGCU4mJVEeD/6A4V4UxIrq1KL8uOLSnNS
	iw8xJgMdNZFZSjQ5H5im8kriDY1NzE2NTS1NLEzMLEkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qBcek2tkQZ/0SLnP1yKhE8XxSSLpRK2Wy952q71kp7ZsyZDbsXcGbddptwqfGcdJLD
	yYcmDzQ2xXyyllhmZRK0Q6g6o7pjpeWatWde6bpd29jTrLCtVGHH2/vpE1s5vq18tnSdxhx1
	TWXHqaEerz8ktZp8a2gziPI8bMnLsq64JkEuSsJddHmlEktxRqKhFnNRcSIAq+GZN0kDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Checking if the probing device has a parent device was just to discover
if the probing device is involved in a power domain when the power
domain controlled by Samsung's custom implementation.
Since generic IO power domain is applied, it is required to remove
the condition to see if the probing device has a parent device.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 6915235..ef771a2 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -558,8 +558,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	if (dev->parent)
-		pm_runtime_enable(dev);
+	pm_runtime_enable(dev);
 
 	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
 	return 0;
-- 
1.7.9.5

