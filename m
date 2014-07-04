Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030976AbaGDWUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:20:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030527AbaGDWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:20:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Javi Merino <javi.merino@arm.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Tushar Behera <tushar.b@samsung.com>
Subject: [PATCH 3.14 01/59] ARM: dts: disable MDMA1 node for exynos5420
Date: Fri,  4 Jul 2014 15:18:50 -0700
Message-Id: <20140704221539.618280417@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221539.544876024@linuxfoundation.org>
References: <20140704221539.544876024@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungwon Jeon <tgih.jun@samsung.com>

commit e6015c1f8a9032c2aecb78d23edf49582563bd47 upstream.

This change places MDMA1 in disabled node for Exynos5420.
If MDMA1 region is configured with secure mode, it makes
the boot failure with the following on smdk5420 board.
("Unhandled fault: imprecise external abort (0x1406) at 0x00000000")
Thus, arndale-octa board don't need to do the same thing anymore.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Tested-by: Javi Merino <javi.merino@arm.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Tushar Behera <tushar.b@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Tested on top of v3.14.10.
Fixes issue reported at [1].
[1]
http://armcloud.us/kernel-ci/stable/v3.14.10/arm-exynos_defconfig/boot-exynos5420-arndale-octa.html

 arch/arm/boot/dts/exynos5420.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -323,6 +323,13 @@
 			#dma-cells = <1>;
 			#dma-channels = <8>;
 			#dma-requests = <1>;
+			/*
+			 * MDMA1 can support both secure and non-secure
+			 * AXI transactions. When this is enabled in the kernel
+			 * for boards that run in secure mode, we are getting
+			 * imprecise external aborts causing the kernel to oops.
+			 */
+			status = "disabled";
 		};
 	};
 


