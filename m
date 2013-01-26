Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab3AZFTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 00:19:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47802 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3AZFTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 00:19:42 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-9d-5103676c99a3
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: fix to refer NULL pointer
Date: Sat, 26 Jan 2013 14:19:49 +0900
Message-id: <1359177589-13868-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t8zXd2cdOZAg48t4haXd81hszjyv5/R
	gcnj8ya5AMYoLpuU1JzMstQifbsErow3z/cwFfxlq2g/cZG5gfEbaxcjJ4eEgInEizW3mSBs
	MYkL99azdTFycQgJLGOUuPN8FRtM0czTp6ASixglZv14yAiSEBJoYZK4sNQExGYT0JO4s+04
	2CQRASGJ782TWEBsZgFriZ8/WsG2CQvoSxzfdYwdxGYRUJW4sOclWA2vgLvE9/l7gWo4gJYp
	SMyZZAOyS0LgAJvEiZ93mCHqBSS+TT7EAlEjK7HpADPEbZISB1fcYJnAKLiAkWEVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRkhoSe1gXNlgcYhRgINRiYe34hRToBBrYllxZe4hRgkOZiUR
	XhkToBBvSmJlVWpRfnxRaU5q8SHGZKDlE5mlRJPzgWGfVxJvaGxgbGhoaWhmamlqQJqwkjgv
	46knAUIC6YklqdmpqQWpRTBbmDg4pRoYC3bsmrN43Y1PFxVlnm3bkTmpvmLfEknXns93kwWS
	PkV+7869fEyh4Tmn6uuFASeSJ5gYXfiUX+amsqKE7YtNbZZuo/0ht6Bf7ZePWXBk8kzz/PZf
	6cDG1gVrrkZMWH1+L3e0wPyPVyMENz0OUG2pC/yrm7eLfZ/8T2u9It7F1zL+Wkhw1+k7K7EU
	ZyQaajEXFScCADNjKqRxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgG5OOnOgQddkIYvLu+awWRz538/o
	wOTxeZNcAGNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+A
	rltmDtBoJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGm+d7mAr+slW0
	n7jI3MD4jbWLkZNDQsBEYubpU2wQtpjEhXvrgWwuDiGBRYwSs348ZARJCAm0MElcWGoCYrMJ
	6Enc2XacCcQWERCS+N48iQXEZhawlvj5oxVsqLCAvsTxXcfYQWwWAVWJC3tegtXwCrhLfJ+/
	F6iGA2iZgsScSTYTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO3GdSOxhXNlgc
	YhTgYFTi4a04xRQoxJpYVlyZe4hRgoNZSYRXxgQoxJuSWFmVWpQfX1Sak1p8iDEZaPlEZinR
	5HxgVOWVxBsam5gZWRqZGZuYGxuTJqwkzst46kmAkEB6YklqdmpqQWoRzBYmDk6pBkbRNyd6
	f4V3FfwwuOiuMWXH2ZVx6ybONfzE9H1hkdQxf9sjb0ujrPti/ZjElblvH9kU8o1ZylKx9sxe
	5dvt/5JkD9icXsDM1xSs7C7h+viNr/axZo6PictOzjJ5vYpfMIbbkCc8L+hP1i/GN7MvSmyM
	jDQ6YybA2KRrGnTtUeelfzvvqk98IqnEUpyRaKjFXFScCADBHPyhoAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether host->sdio_irq_thread is NULL before wake_up_process() is
called about host->sdio_irq_thread.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
Currently the kernel panic to refer NULL pointer about
host->sdio_irq_thread are occuring at the trats board using Samsung
SDHCI driver.

 include/linux/mmc/host.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 61a10c1..2950fea 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -372,7 +372,8 @@ static inline void mmc_signal_sdio_irq(struct mmc_host *host)
 {
 	host->ops->enable_sdio_irq(host, 0);
 	host->sdio_irq_pending = true;
-	wake_up_process(host->sdio_irq_thread);
+	if (host->sdio_irq_thread)
+		wake_up_process(host->sdio_irq_thread);
 }
 
 #ifdef CONFIG_REGULATOR
-- 
1.7.9.5

