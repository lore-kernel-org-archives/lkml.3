Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaK1PTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:19:19 -0500
Received: from sender1.zohomail.com ([72.5.230.103]:29937 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaK1PTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:19:18 -0500
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 10:19:18 EST
From: =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, joshc@codeaurora.org,
        johannes.thumshirn@men.de, kheitke@codeaurora.org,
        laurent.pinchart+renesas@ideasonboard.com, geert+renesas@glider.be,
        horms+renesas@verge.net.au, damm@opensource.se, tomi.valkeinen@ti.com,
        mbohan@codeaurora.org, michal.simek@xilinx.com
Cc: pawel.moll@arm.com, Andrew.Thoelke@arm.com, javier@javigon.com
Subject: [RFC PATCH 0/3] Generic TrustZone Driver in Linux Kernel
Date: Fri, 28 Nov 2014 16:03:33 +0100
Message-Id: <1417187016-7731-1-git-send-email-javier@javigon.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_19114_172
X-ZohoMail-Owner: <1417187016-7731-1-git-send-email-javier@javigon.com>+zmo_0_<javier@javigon.com>
X-ZohoMail-Sender: 130.226.133.124
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This set of patches is a first iteration to introduce a generic
TrustZone driver to the Linux Kernel. Since there is no place to add
drivers related to secure processors, a new subsystem for secure
hardware in general (drivers/sechw) is also introduced. TPM is a good
candidate to me moved here if this change is accepted.

Today, TrustZone solutions are implementation specific. In user space,
mobile devices are normally compliant with Global Platform's API
<http://www.globalplatform.org>. However, there is no common TrustZone
interface for kernel space, as it exists for Trusted Computing Module
(TPM). As a result, different TrustZone frameworks use different kernel
loadable modules to provide the context to communicate with the Trusted
Execution Environment leveraged by TrustZone's secure world.

Regarding use cases, TrustZone has traditionally been used for
offloading secure tasks to the secure world. Examples include banking
applications, Digital Rights Management (DRM), or specific secure
solutions. As more and more frameworks enabling TrustZone appear, new
use cases are starting to emerge: key management, encryption, integrity
checking, etc. Extreme cases today involve running a RTOS in the secure
world, or using the secure world toimplement usage control policies
governing the normal world. The advent of ARMv8 will only expand this
list.

This set of patches introduce a generic TrustZone driver for kernel
space. The first design goal is to be flexible enough as to NOT
introduce policy regarding the TrustZone interface. In this way, we
introduce a session-based open/close read/write interface where
several TrustZone drivers can potentially be used. The design is
simple and it consist on an interface that different TrustZone drivers
can implement to communicate with the specific frameworks.

Major TODO's:
 * Patch has TODOs, FIXMEs and XXXs that need to be cleaned.
 * Refactor part of Open Virtualization's driver. Some part are complex
 * and can be simplified.
 * Add support for different boards. At the moment only zynq-7000 ZC702
 is supported. A sepparate patch containing the patch for ZC702 will be
 sent sepparately - rebasing from 3.8 to 3.17 at the moment.

Development is taking place at:
	https://github.com/TrustZoneGenericDriver/linux-xlnx tz_driver
At 14.5_trd_tz_driver_generic it can be found the same driver together
with TEE support for Zynq ZC702 in 3.8

Since all testing is being done in the Xilinx ZC702 board, using
Xilinx's Linux tree is convenient. Once the board rebasing to 3.17 is
completed, development will move to:
	https://github.com/TrustZoneGenericDriver/linux

Feedback regarding the code, the interface, or its placement in
drivers/sechw is more than welcome. The idea is to refine ths TrustZone
driver while working on supporting more targets.

Thanks,

Javier.

Javier Gonzalez (3):
  Add generic TrustZone driver
  Open Virtualization driver
  TrustZone driver: wrap OV driver

 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    2 +
 drivers/sechw/Kconfig                     |   11 +
 drivers/sechw/Makefile                    |    5 +
 drivers/sechw/trustzone/Kconfig           |   32 +
 drivers/sechw/trustzone/Makefile          |    8 +
 drivers/sechw/trustzone/otz_api.h         | 1318 ++++++++++
 drivers/sechw/trustzone/otz_client.h      |  127 +
 drivers/sechw/trustzone/otz_client_main.c | 3803 +++++++++++++++++++++++++++++
 drivers/sechw/trustzone/otz_common.h      |  112 +
 drivers/sechw/trustzone/otz_id.h          |  246 ++
 drivers/sechw/trustzone/smc_id.h          |   75 +
 drivers/sechw/trustzone/sw_common_types.h |   35 +
 drivers/sechw/trustzone/sw_config.h       |   40 +
 drivers/sechw/trustzone/trustzone.c       |  349 +++
 drivers/sechw/trustzone/trustzone.h       |   68 +
 include/linux/trustzone.h                 |   95 +
 17 files changed, 6328 insertions(+)

-- 
1.9.1


