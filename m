Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3IYAU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab3IYAUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arun Kumar K <arun.kk@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [ 084/117] media: exynos4-is: Fix fimc-lite bayer formats
Date: Tue, 24 Sep 2013 17:19:10 -0700
Message-Id: <20130925001750.131326193@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/exynos4-is/fimc-lite.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -90,7 +90,7 @@ static const struct fimc_fmt fimc_lite_f
 		.name		= "RAW10 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
-		.depth		= { 10 },
+		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW10,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
@@ -99,7 +99,7 @@ static const struct fimc_fmt fimc_lite_f
 		.name		= "RAW12 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
-		.depth		= { 12 },
+		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW12,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,


