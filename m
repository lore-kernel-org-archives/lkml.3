Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaCZOTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:19:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8940 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaCZOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:19:49 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-62-5332e20425b1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-ide@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: fix R-Car SATA driver dependencies
Date: Wed, 26 Mar 2014 15:19:23 +0100
Message-id: <4494466.bbG3GqUbue@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jQV2WR0bBBqtf8Vo0b/3KaLHp8TVW
	i2M7HjFZXN41h81izp8pzBYPVr9ls/i1/CijA7vHzll32T02repk89i8pN5jzs9vLB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZTQ/a2IrOMFe8eX5BpYGxlVsXYycHBICJhLPW/9B2WISF+6tB7K5
	OIQEpjNKbLzylR3CaWGSeH5sAQtIFZuAlcTE9lWMILaIgKzElWkPGUGKmAWOM0r03rgMViQs
	YCHxqO03WBGLgKrElRv3mUFsXgFNiQd3vjCB2KICnhI7tq9kg4gLSvyYfA+sl1lAXmLf/qms
	ELaWxPqdx5kmMPLNQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh+0z
	qR2MKxssDjEKcDAq8fDuuG8ULMSaWFZcmXuIUYKDWUmEV/gGUIg3JbGyKrUoP76oNCe1+BCj
	NAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjyS8HPz56Hfr2bIHxxk9PMxc/Y9yfpx0b
	eXzSzjfNjs9msNzi+L8gl+2IpAFv2o+SstqZnHcKHnBPDGg1ip28d17q7rYzAYWCgQXyr2f+
	nF9YJ3m4Y8nNmf53OzIbPkuwpp4XOLssSeB0f+k0pUKHwuq+R7E3SxKEXl0KTL6+88f2qfOM
	zybfUWIpzkg01GIuKk4EADo02ftXAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sata_rcar host driver depend on ARCH_SHMOBILE config option as
Renesas R-Car SATA support is specific to Renesas SoCs and the driver
to work requires suitable device tree node (or platform device) to be
defined.  Additionally allow the driver build if COMPILE_TEST config
option is set.

Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig	2014-03-25 20:08:10.220311027 +0100
+++ b/drivers/ata/Kconfig	2014-03-26 15:09:04.259143796 +0100
@@ -298,6 +298,7 @@ config SATA_PROMISE
 
 config SATA_RCAR
 	tristate "Renesas R-Car SATA support"
+	depends on ARCH_SHMOBILE || COMPILE_TEST
 	help
 	  This option enables support for Renesas R-Car Serial ATA.
 

