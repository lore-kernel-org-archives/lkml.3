Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbaFEA2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:28:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaFDXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 104/228] ARM: orion5x: fix target ID for crypto SRAM window
Date: Wed,  4 Jun 2014 16:22:13 -0700
Message-Id: <20140604232351.377649197@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 1cc9d48145b81e307fab94a5cf6ee66ec2f0de60 upstream.

In commit 4ca2c04085a1caa903e92a5fc0da25362150aac2 ('ARM: orion5x:
Move to ID based window creation'), the mach-orion5x code was changed
to use the new mvebu-mbus API. However, in the process, a mistake was
made on the crypto SRAM window target ID: it should have been 0x9
(verified in the datasheet) and not 0x0.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Link: https://lkml.kernel.org/r/1397400006-4315-2-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: 4ca2c04085a1 ('ARM: orion5x: Move to ID based window creation')
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-orion5x/common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-orion5x/common.h
+++ b/arch/arm/mach-orion5x/common.h
@@ -21,7 +21,7 @@ struct mv_sata_platform_data;
 #define ORION_MBUS_DEVBUS_BOOT_ATTR   0x0f
 #define ORION_MBUS_DEVBUS_TARGET(cs)  0x01
 #define ORION_MBUS_DEVBUS_ATTR(cs)    (~(1 << cs))
-#define ORION_MBUS_SRAM_TARGET        0x00
+#define ORION_MBUS_SRAM_TARGET        0x09
 #define ORION_MBUS_SRAM_ATTR          0x00
 
 /*


