Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaEWK0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:26:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17087 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaEWKZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:25:27 -0400
X-AuditID: cbfee690-b7fb56d000003439-38-537f2213e31e
From: Jaehoon Chung <jh80.chung@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH 1/3] mmc: host: add slot argument to mmc_of_parse
Date: Fri, 23 May 2014 19:25:19 +0900
Message-id: <1400840721-11050-2-git-send-email-jh80.chung@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
References: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkSFdYqT7Y4MtpQ4sJl7czWsw/co7V
	4savNlaLy7vmsFkc+d/PaDHj/D4mi0Mzky0+3L/IbHF8bbgDp8eCX1tZPO5c28PmcePVQiaP
	vi2rGD0+b5ILYI3isklJzcksSy3St0vgyvh+w7rgpmjFw5NvWRoYnwh2MXJySAiYSOyYf50N
	whaTuHBvPZDNxSEksJRR4s3/+UwwRa+3zWaGSCxilDj8pYcJwmljkmi7foIFpIpNQEdi+7fj
	YB0iArISP/9cABvFLLCaSeLo8t9A7RwcwgKOEl23S0BqWARUJdYcv8IIEuYVcJPYvU0AxJQQ
	UJCYM8kGpIJTwF1i3tyLrCC2EFDFh+3zwCZKCKxjlzi0sIcZYoyAxLfJh1ggemUlNh1ghrhZ
	UuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIDPnT/55N2MF474D1IcZk
	oHETmaVEk/OBMZNXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYyc069tSP15eIa/xdGqCc+/piw8YHLf2Dnm67UNX/6XiZ/Jjfh/cMPJU0vV7oof
	DRI2+VCc6BjjJNf8+hvrNakyLWvTR77tq8viAg5ubN+elafU8O5c7HMtb73dnn82/b2XFL+x
	R+mIw2rvhy+XRM/8mPjlVfqi7fGpFnYvt0pf+15XsuiC3o8EJZbijERDLeai4kQA4EmQKo8C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAV1hpfpggysv1CwmXN7OaDH/yDlW
	ixu/2lgtLu+aw2Zx5H8/o8WM8/uYLA7NTLb4cP8is8XxteEOnB4Lfm1l8bhzbQ+bx41XC5k8
	+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG9xvWBTdF
	Kx6efMvSwPhEsIuRk0NCwETi9bbZzBC2mMSFe+vZuhi5OIQEFjFKHP7SwwThtDFJtF0/wQJS
	xSagI7H923EmEFtEQFbi558LYB3MAquZJI4u/w00ioNDWMBRout2CUgNi4CqxJrjVxhBwrwC
	bhK7twmAmBICChJzJtmAVHAKuEvMm3uRFcQWAqr4sH0e2wRG3gWMDKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxgiPqmdQOxpUNFocYBTgYlXh4HzDVBQuxJpYVV+YeYpTgYFYS4T0jWx8s
	xJuSWFmVWpQfX1Sak1p8iDEZ6KaJzFKiyfnAaM8riTc0NjEzsjQyN7QwMjYnTVhJnPdAq3Wg
	kEB6YklqdmpqQWoRzBYmDk6pBsape2LObbZ7y3XdIIbZsrD7hHKZRtLis+puNzfa/nNWc7mY
	YbWpMaJw6VqzlPk653Y2J5/W+B5g8fSzeOZWXu/7FT+mXmlyeyb7zfRzYMjxmQm7zxxbO/vg
	pKq03vgQ1n+Lr8kIn321aVNnzVr2E9p66/fv/wAM6z83dD7rHq5bFN2ccPzFNUslluKMREMt
	5qLiRACiAkRV7AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

Some hosts manage several slots. In these case information such as the
bus width, chi detect and others are into the slot node. So we have to
parse child node. If not NULL, slot node will be used instead of the
device node.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
---
 drivers/mmc/core/host.c  |   13 +++++++++----
 include/linux/mmc/host.h |   10 +++++++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 95cceae..0f677b3 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -298,15 +298,17 @@ static inline void mmc_host_clk_sysfs_init(struct mmc_host *host)
 #endif
 
 /**
- *	mmc_of_parse() - parse host's device-tree node
+ *	__mmc_of_parse() - parse host's device-tree node
  *	@host: host whose node should be parsed.
+ *	@slot : some device provide several slots so the node to parse
+ *		is not the host one.
  *
  * To keep the rest of the MMC subsystem unaware of whether DT has been
  * used to to instantiate and configure this host instance or not, we
  * parse the properties and set respective generic mmc-host flags and
  * parameters.
  */
-int mmc_of_parse(struct mmc_host *host)
+int __mmc_of_parse(struct mmc_host *host, struct device_node *slot)
 {
 	struct device_node *np;
 	u32 bus_width;
@@ -317,7 +319,10 @@ int mmc_of_parse(struct mmc_host *host)
 	if (!host->parent || !host->parent->of_node)
 		return 0;
 
-	np = host->parent->of_node;
+	if (slot)
+		np = slot;
+	else
+		np = host->parent->of_node;
 
 	/* "bus-width" is translated to MMC_CAP_*_BIT_DATA flags */
 	if (of_property_read_u32(np, "bus-width", &bus_width) < 0) {
@@ -459,7 +464,7 @@ out:
 	return ret;
 }
 
-EXPORT_SYMBOL(mmc_of_parse);
+EXPORT_SYMBOL(__mmc_of_parse);
 
 /**
  *	mmc_alloc_host - initialise the per-host structure.
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7960424..c62af91 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -372,7 +372,15 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *);
 int mmc_add_host(struct mmc_host *);
 void mmc_remove_host(struct mmc_host *);
 void mmc_free_host(struct mmc_host *);
-int mmc_of_parse(struct mmc_host *host);
+int __mmc_of_parse(struct mmc_host *host, struct device_node *slot);
+/*
+ * mmc_of_parse - parse host's device-tree node
+ *	@host: host whose node should be parsed.
+ */
+static inline int mmc_of_parse(struct mmc_host *host)
+{
+	return __mmc_of_parse(host, NULL);
+}
 
 static inline void *mmc_priv(struct mmc_host *host)
 {
-- 
1.7.9.5

