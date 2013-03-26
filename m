Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3CZXc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:32:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3CZWoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takahisa Tanaka <mc74hc00@gmail.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [ 74/98] watchdog: sp5100_tco: Set the AcpiMmioSel bitmask value to 1 instead of 2
Date: Tue, 26 Mar 2013 15:43:03 -0700
Message-Id: <20130326224250.167607022@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takahisa Tanaka <mc74hc00@gmail.com>

commit 81fc933f176cd95f757bfc8a98109ef422598b79 upstream.

The AcpiMmioSel bit is bit 1 in the AcpiMmioEn register, but the current
sp5100_tco driver is using bit 2.

See 2.3.3 Power Management (PM) Registers page 150 of the
AMD SB800-Series Southbridges Register Reference Guide [1].

        AcpiMmioEn - RW – 8/16/32 bits - [PM_Reg: 24h]
        Field Name        Bits  Default  Description
        AcpiMMioDecodeEn  0     0b       Set to 1 to enable AcpiMMio space.
        AcpiMMIoSel       1     0b       Set AcpiMMio registers to be memory-mapped or IO-mapped space.
                                         0: Memory-mapped space
                                         1: I/O-mapped space

The sp5100_tco driver expects zero as a value of AcpiMmioSel (bit 1).

Fortunately, no problems were caused by this typo, because the default
value of the undocumented misused bit 2 seems to be zero.

However, the sp5100_tco driver should use the correct bitmask value.

[1] http://support.amd.com/us/Embedded_TechDocs/45482.pdf

Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/sp5100_tco.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -57,7 +57,7 @@
 #define SB800_PM_WATCHDOG_DISABLE	(1 << 2)
 #define SB800_PM_WATCHDOG_SECOND_RES	(3 << 0)
 #define SB800_ACPI_MMIO_DECODE_EN	(1 << 0)
-#define SB800_ACPI_MMIO_SEL		(1 << 2)
+#define SB800_ACPI_MMIO_SEL		(1 << 1)
 
 
 #define SB800_PM_WDT_MMIO_OFFSET	0xB00


