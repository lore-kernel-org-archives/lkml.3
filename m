Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbaAJLpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:45:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32581 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaAJLpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:45:15 -0500
X-AuditID: cbfee68f-b7f156d00000276c-f6-52cfdd4a52bb
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: [PATCH 8/8 v3] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Fri, 10 Jan 2014 17:15:31 +0530
Message-id: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkWtfr7vkgg86n3BYvD2ladL+Ssbh/
	7yeTxeVdc9gsZpzfx2SxaNt/ZotVu/4wWpydc4jJgcNj56y77B7bDqh69G1ZxejxeZNcAEsU
	l01Kak5mWWqRvl0CV8be1lUsBXM4K7rfHGVuYLzI3sXIySEhYCIxbcJxFghbTOLCvfVsXYxc
	HEICSxkl9pw8xAJT1Lj2NVRiOqPEw7X7WSGcfiaJmdc+MINUsQmYSRxctBpsrIiAs8Tv5jVg
	RcwCc4A6lrSDjRIWcJX4sWgCK4jNIqAq8W3CQiYQmxco/r19JVAzB9A6BYk5k2xAeiUEfrNJ
	9CzbwgZRLyDxbTLISSA1shKbDjBDXCcpcXDFDZYJjIILGBlWMYqmFiQXFCelFxnrFSfmFpfm
	pesl5+duYgSG7Ol/z/p3MN49YH2IMRlo3ERmKdHkfGDI55XEGxqbGVmYmpgaG5lbmpEmrCTO
	e/9hUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxtUVed3zdp+yilSfYvetR0769ocbZ+SU
	/3DFxL7pzCwIuH1VVedm236DhhABace1rVfeXZp1/XPS8/BLrlGvX1yuyg7W3DovqU9pRnqu
	YvkT7stvpRZ2rw/Q8k1P09q/PPA1495uo3nbX8VtldnxsUPqx+5f86KFPl5r3G8cyLFvYqy/
	2eQGGyWW4oxEQy3mouJEANlMi15vAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV2vu+eDDF7uZbZ4eUjTovuVjMX9
	ez+ZLC7vmsNmMeP8PiaLRdv+M1us2vWH0eLsnENMDhweO2fdZffYdkDVo2/LKkaPz5vkAlii
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COUFIo
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm7G1dxVIwh7Oi+81R5gbGi+xd
	jJwcEgImEo1rX7NB2GISF+6tB7K5OIQEpjNKPFy7nxXC6WeSmHntAzNIFZuAmcTBRavBukUE
	nCV+N68BK2IWmAPUsaSdBSQhLOAq8WPRBFYQm0VAVeLbhIVMIDYvUPx7+0qgZg6gdQoScybZ
	TGDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOCKeSe9gXNVgcYhRgINRiYe3YNb5
	ICHWxLLiytxDjBIczEoivOYXgEK8KYmVValF+fFFpTmpxYcYk4GWT2SWEk3OB0ZrXkm8obGJ
	uamxqaWJhYmZJWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwLv6TmKLWs2O2Zkhcr8HH
	5VKb0kRVOj0DFb98ZksVenHpsKbk++Wvqsy32i0XFWJVZ5x7wXbZD7ai07a9JbuvnD87jZNx
	hsKNI6+MyjkvHXxhVKJx4LLn76T0ydtYrq7JPnrtl/Dat6tbe2u3uTO2sf83PsAbaMP+ySqn
	YRfTspPt+y4u+HPUSYmlOCPRUIu5qDgRAGUTSMLMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds use of clk_prepare/clk_unprepare as
required by generic clock framework.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v2:
New change to fix a WARN_ON during the bootup

 drivers/crypto/s5p-sss.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 7058bb6..3db7e52 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -653,7 +653,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_enable(pdata->clk);
+	clk_prepare_enable(pdata->clk);
 
 	spin_lock_init(&pdata->lock);
 	pdata->ioaddr = devm_ioremap(dev, res->start,
@@ -714,7 +714,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
  err_irq:
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
@@ -734,7 +734,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
 
 	tasklet_kill(&pdata->tasklet);
 
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
-- 
1.7.9.5

