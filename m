Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbaAFXBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:01:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbaAFWmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 124/129] arm64: dts: Reserve the memory used for secondary CPU release address
Date: Mon,  6 Jan 2014 14:39:13 -0800
Message-Id: <20140106223903.144985951@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit df503ba7f653c590b475ab80bde788edf5af70d5 upstream.

With the spin-table SMP booting method, secondary CPUs poll a location
passed in the DT. The foundation-v8.dts file doesn't have this memory
reserved and there is a risk of Linux using it before secondary CPUs are
started.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/foundation-v8.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/foundation-v8.dts
+++ b/arch/arm64/boot/dts/foundation-v8.dts
@@ -6,6 +6,8 @@
 
 /dts-v1/;
 
+/memreserve/ 0x80000000 0x00010000;
+
 / {
 	model = "Foundation-v8A";
 	compatible = "arm,foundation-aarch64", "arm,vexpress";


