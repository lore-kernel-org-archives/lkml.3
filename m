Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3EQGWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 02:22:12 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25597 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3EQGWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 02:22:11 -0400
Message-ID: <5195CC6B.1000607@huawei.com>
Date: Fri, 17 May 2013 14:21:31 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <ralf@linux-mips.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>
CC: <linux-mips@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] MIPS: drivers: fix clk leak
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when gptu_r32 fail, we should put clk before return

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 arch/mips/lantiq/xway/gptu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
index 9861c86..4fa577c 100644
--- a/arch/mips/lantiq/xway/gptu.c
+++ b/arch/mips/lantiq/xway/gptu.c
@@ -169,6 +169,8 @@ static int gptu_probe(struct platform_device *pdev)
 	if (((gptu_r32(GPTU_ID) >> 8) & 0xff) != GPTU_MAGIC) {
 		dev_err(&pdev->dev, "Failed to find magic\n");
 		gptu_hwexit();
+		clk_disable(clk);
+		clk_put(clk);
 		return -ENAVAIL;
 	}

-- 
1.7.1

