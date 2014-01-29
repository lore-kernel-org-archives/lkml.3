Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaA2J2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:28:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16677 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaA2J0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:26:08 -0500
X-AuditID: cbfee68f-b7f156d00000276c-26-52e8c92fb7a4
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org
Subject: [PATCH 8/9 v5] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Wed, 29 Jan 2014 14:56:01 +0530
Message-id: <1390987561-18914-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkRlf/5Isgg+nbBCxeHtK0mH/kHKtF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHzll32T22HVD16NuyitHj8ya5AJYo
	LpuU1JzMstQifbsEroz2xz9YCy5wVcye3MfawPiQo4uRk0NCwERi8sn57BC2mMSFe+vZuhi5
	OIQEljJKPD59ghWm6ObqhUwQiUWMEm+2PmCEcPqZJHZM3MoGUsUmYCZxcNFqsFEiAs4Sv5vX
	sIIUMQssZJRY9e0vM0hCWMBVYnnDNSYQm0VAVeJb33ywOC9QvH3jYaAGDqB1ChJzJtmAhDkF
	3CTuz3jFAmILAZU8nDoBbKaEwDx2iVNHn7BDzBGQ+Db5EAtEr6zEpgPMEFdLShxccYNlAqPw
	AkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBIX7637P+HYx3D1gfYkwGGjeRWUo0OR8Y
	I3kl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXFT
	FfeXwqkftNc337u1N/Jk9LLjPDL93GlxOxMmKi75NjW/OCP90OmtxozpT1zrjs5aHrLC9uqZ
	868btJ21u5p9VCqY2/J4kufyupzi+sZ4N/f4uqzIkimhjvXr+S8v+FUpunyejpd3wqXa8GeP
	mi4dLbc2nMTDJ2ChzFpz8YXc0gmtSxmvH1BiKc5INNRiLipOBADAsNbfhwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAV39ky+CDFau5rB4eUjTYv6Rc6wW
	3a9kLO7f+8lkcXnXHDaLGef3MVks2vaf2eLsnENMDhweO2fdZffYdkDVo2/LKkaPz5vkAlii
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COUFIo
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmtD/+wVpwgati9uQ+1gbGhxxd
	jJwcEgImEjdXL2SCsMUkLtxbz9bFyMUhJLCIUeLN1geMEE4/k8SOiVvZQKrYBMwkDi5azQ5i
	iwg4S/xuXsMKUsQssJBRYtW3v8wgCWEBV4nlDdfAxrIIqEp865sPFucFirdvPAzUwAG0TkFi
	ziQbkDCngJvE/RmvWEBsIaCSh1MnsE5g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	IziCnkntYFzZYHGIUYCDUYmHd8XF50FCrIllxZW5hxglOJiVRHhPbHoRJMSbklhZlVqUH19U
	mpNafIgxGeioicxSosn5wOjOK4k3NDYxNzU2tTSxMDGzJE1YSZz3QKt1oJBAemJJanZqakFq
	EcwWJg5OqQbG9APh0mtfJs93mXjs26dr9z4HfFLx85gy12jfxyB92wNSZVPObzlnbBbz5cxp
	Ow5zH/nHKZf0l8svXd7rNi9jYpN1Z5X/hJiui1HB5TvK55elbPkYfXNuocwJc+sZ2y73NyTd
	Oa6XU+8fz+u11EQh0j4ybnl90JqQJXP5BJ1Pn0tflfl/PV+4EktxRqKhFnNRcSIAjHL0xOQC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds use of clk_prepare/clk_unprepare as
required by generic clock framework.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
Changes since v4:
Handle return value of clk_prepare_enable

Changes since v3:
None

 drivers/crypto/s5p-sss.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index a890273..5bd3bd9 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -648,7 +648,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_enable(pdata->clk);
+	err = clk_prepare_enable(pdata->clk);
+	if (err < 0) {
+		dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
+		return err;
+	}
 
 	spin_lock_init(&pdata->lock);
 	pdata->ioaddr = devm_ioremap(dev, res->start,
@@ -711,7 +715,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
  err_irq:
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
@@ -731,7 +735,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
 
 	tasklet_kill(&pdata->tasklet);
 
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
-- 
1.7.9.5

