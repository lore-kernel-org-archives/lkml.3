Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3I3KTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:19:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43748 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3I3KNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arun Kumar K <arun.kk@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 081/104] exynos4-is: Fix fimc-lite bayer formats
Date: Mon, 30 Sep 2013 11:10:58 +0100
Message-Id: <1380535881-9239-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun Kumar K <arun.kk@samsung.com>

commit 3396b096c54a84603c51bd705effa88f7f5b0d76 upstream.

The 10-bit and 12-bit Bayer output formats supported by FIMC-LITE
actually use 16 bits where the extra bits are padded with zeros.
The patch corrects buffer allocation for these two formats by
modifying the depth field. This prevents memory corruption by the
output DMA due to insufficient buffer size.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/video/s5p-fimc/fimc-lite.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 9132f61..f35903c 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -75,14 +75,14 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	}, {
 		.name		= "RAW10 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
-		.depth		= { 10 },
+		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW10,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
 	}, {
 		.name		= "RAW12 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
-		.depth		= { 12 },
+		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW12,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,
-- 
1.8.3.2

