Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaAMQas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:30:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaAMQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 133/208] arm64: dts: Reserve the memory used for secondary CPU release address
Date: Mon, 13 Jan 2014 15:59:34 +0000
Message-Id: <1389628849-1614-134-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit df503ba7f653c590b475ab80bde788edf5af70d5 upstream.

With the spin-table SMP booting method, secondary CPUs poll a location
passed in the DT. The foundation-v8.dts file doesn't have this memory
reserved and there is a risk of Linux using it before secondary CPUs are
started.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/boot/dts/foundation-v8.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/foundation-v8.dts b/arch/arm64/boot/dts/foundation-v8.dts
index 84fcc50..519c4b2 100644
--- a/arch/arm64/boot/dts/foundation-v8.dts
+++ b/arch/arm64/boot/dts/foundation-v8.dts
@@ -6,6 +6,8 @@
 
 /dts-v1/;
 
+/memreserve/ 0x80000000 0x00010000;
+
 / {
 	model = "Foundation-v8A";
 	compatible = "arm,foundation-aarch64", "arm,vexpress";
-- 
1.8.3.2

