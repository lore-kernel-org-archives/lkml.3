Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbbAUQoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:44:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40688 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbbAUQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:44:30 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-40-54bfd6da08b6
From: Karol Wrona <k.wrona@samsung.com>
To: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [RFC PATCH 0/1] mmc: dw_mmc: Add runtime pm to dw_mmc
Date: Wed, 21 Jan 2015 17:43:58 +0100
Message-id: <1421858639-14737-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xK7q3ru0PMWg8bWixccZ6Vosbv9pY
	LU4t289kcbbpDbvF5V1z2CyO/O9ntPhw/yKzxfG14RZ71m1hcuD02DnrLrvHnWt72Dz6tqxi
	9Pi8SS6AJYrLJiU1J7MstUjfLoErY+rToywFCzkr/ky8w97AuIq9i5GTQ0LARGJay0cWCFtM
	4sK99WxdjFwcQgJLGSX2tF9ggXD6mCS2zFnLBlLFJqAu0bxjMTNIQkRgM6PEx4Mgo7g4mAXW
	MEqcOTsBbK6wgJ3E/LermUFsFgFViW3f14Pt4BVwljjyejtrFyMH0D4FiTmTbCYwci9gZFjF
	KJpamlxQnJSea6RXnJhbXJqXrpecn7uJERIwX3cwLj1mdYhRgINRiYdXwmd/iBBrYllxZe4h
	RgkOZiURXr+DQCHelMTKqtSi/Pii0pzU4kOMTBycUg2M4gL3Sr/fqi5lVYwv6Vz+9LGB4FKB
	GYdmvpjzcB5DxBmVvb5XunSYti7Z7DlrQ6xMYugqr/WTZNa9vLBXvdJn5q11+6S2rNlfzsMb
	om0xn5ezeYpZGH+KSGyhYbv+P/mpEhes55R9CAhePa0w/+vhGs7Cb0tsUpNe3RZ0XD5dZZNL
	5cw31kZRSizFGYmGWsxFxYkASTuogvYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch adds runtime pm for dwmmc host.  Runtime PM is enabled for
dwmmc-exynos.  This is RFC because I need some opinion about the host state
detection and handling and is not finished.  The runtime pm suspend and resume
callback are empty for now because the main goal of this path is adding mmc
host to the pm runtime what in effect will give an information to the PM core.
As mshc will be added to some power domain.  This will help to know mmc host
state by PM and enter Exynos LPD state.  LPD is system level power control
mode.  In LPD, the supporting it, unused blocks are power and clock gated.

I will also look something to add to runtime callbacks to decrease power
consumption by the dw_mmc host during normal power mode but this is very tight
because clk to the card is gated in some dw_mmc modes (where there is no 
communication).
 
Thanks,
Karol

Karol Wrona (1):
  mmc: dw_mmc: Add runtime pm to dw_mmc

 drivers/mmc/host/dw_mmc-exynos.c |   69 ++++++++++++++++++++++++++++++++++++--
 drivers/mmc/host/dw_mmc.c        |   65 +++++++++++++++++++++++++++++++++--
 2 files changed, 130 insertions(+), 4 deletions(-)

-- 
1.7.9.5

