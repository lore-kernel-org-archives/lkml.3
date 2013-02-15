Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935949Ab3BOMpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935913Ab3BOMpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:17 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 00/13] Add a driver to report Firmware first errors (via GHES)
Date: Fri, 15 Feb 2013 10:44:48 -0200
Message-Id: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently 3 error mechanisms inside the Linux Kernel:
edac, mcelog and ghes.

Unfortunately, not all those error mechanisms will work at the same
time, as accessing the error registers by the BIOS may interfere on
reading them from OS.

So, all those 3 mechanisms need to be integrated, in order to avoid
such problems.

This patch series adds a new EDAC driver that uses "Firmware first"
APEI/GHES as an error report mechanism. It automatically disables
the hardware-driven EDAC drivers when GHES is enabled, preventing
to have both OS and BIOS to read at the very same error mechanisms.

It was tested on a "Lizard Head Pass" Intel machine, equipped with
BIOS SE5C600.86B.99.99.x059.091020121352 (09/10/2012).

Test results:

The driver is properly binding into the EDAC core. This BIOS
announces and sets "Firmware first" mode:

[    4.537704] ghes_edac: This EDAC driver relies on BIOS to enumerate memory and get error reports.
[    4.547644] ghes_edac: Unfortunately, not all BIOSes reflect the memory layout correctly.
[    4.556807] ghes_edac: So, the end result of using this driver varies from vendor to vendor.
[    4.566260] ghes_edac: If you find incorrect reports, please ask your vendor to fix its BIOS.
[    4.575811] ghes_edac: This system has 48 DIMM sockets.
[    4.581687] EDAC DEBUG: ghes_edac_dmidecode: DIMM0: DDR3 size = 8192 MB(ECC)
[    4.581691] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581695] EDAC DEBUG: ghes_edac_dmidecode: DIMM3: DDR3 size = 8192 MB(ECC)
[    4.581698] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581702] EDAC DEBUG: ghes_edac_dmidecode: DIMM6: DDR3 size = 8192 MB(ECC)
[    4.581705] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581708] EDAC DEBUG: ghes_edac_dmidecode: DIMM9: DDR3 size = 8192 MB(ECC)
[    4.581711] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581715] EDAC DEBUG: ghes_edac_dmidecode: DIMM12: DDR3 size = 8192 MB(ECC)
[    4.581718] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581722] EDAC DEBUG: ghes_edac_dmidecode: DIMM15: DDR3 size = 8192 MB(ECC)
[    4.581724] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581728] EDAC DEBUG: ghes_edac_dmidecode: DIMM18: DDR3 size = 8192 MB(ECC)
[    4.581730] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581734] EDAC DEBUG: ghes_edac_dmidecode: DIMM21: DDR3 size = 8192 MB(ECC)
[    4.581737] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581741] EDAC DEBUG: ghes_edac_dmidecode: DIMM24: DDR3 size = 8192 MB(ECC)
[    4.581752] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581756] EDAC DEBUG: ghes_edac_dmidecode: DIMM27: DDR3 size = 8192 MB(ECC)
[    4.581759] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581763] EDAC DEBUG: ghes_edac_dmidecode: DIMM30: DDR3 size = 8192 MB(ECC)
[    4.581766] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581769] EDAC DEBUG: ghes_edac_dmidecode: DIMM33: DDR3 size = 8192 MB(ECC)
[    4.581772] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581776] EDAC DEBUG: ghes_edac_dmidecode: DIMM36: DDR3 size = 8192 MB(ECC)
[    4.581778] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581782] EDAC DEBUG: ghes_edac_dmidecode: DIMM39: DDR3 size = 8192 MB(ECC)
[    4.581784] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581788] EDAC DEBUG: ghes_edac_dmidecode: DIMM42: DDR3 size = 8192 MB(ECC)
[    4.581791] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.581795] EDAC DEBUG: ghes_edac_dmidecode: DIMM45: DDR3 size = 8192 MB(ECC)
[    4.581797] EDAC DEBUG: ghes_edac_dmidecode: 	type 24, detail 0x80, width 72(total 64)
[    4.582724] EDAC MC0: Giving out device to 'ghes_edac.c' 'ghes_edac': DEV ghes
[    4.591145] EDAC MC1: Giving out device to 'ghes_edac.c' 'ghes_edac': DEV ghes
[    4.599524] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.

However, with this BIOS, the "Firmware first" is not working. The
errors are only seen via MCELOG error mechanism:

# mcelog
Hardware event. This is not a software error.
MCE 0
CPU 0 BANK 5 
MISC 20404c4c86 ADDR 320000 
TIME 1360931174 Fri Feb 15 07:26:14 2013
MCG status:
MCi status:
Corrected error
MCi_MISC register valid
MCi_ADDR register valid
MCA: MEMORY CONTROLLER RD_CHANNEL0_ERR
Transaction: Memory read error
STATUS 8c00004000010090 MCGSTATUS 0
MCGCAP 1000c14 APICID 0 SOCKETID 0 
CPUID Vendor Intel Family 6 Model 45
Hardware event. This is not a software error.

So, I was unable to test the GHES->EDAC error report method.

Mauro Carvalho Chehab (13):
  edac: lock module owner to avoid error report conflicts
  ghes: move structures/enum to a header file
  ghes: add the needed hooks for EDAC error report
  edac: add a new memory layer type
  ghes_edac: Register at EDAC core the BIOS report
  ghes_edac: Allow registering more than once
  edac: add support for raw error reports
  ghes_edac: add support for reporting errors via EDAC
  ghes_edac: do a better job of filling EDAC DIMM info
  edac: better report error conditions in debug mode
  edac: initialize the core earlier
  ghes_edac.c: Don't credit the same memory dimm twice
  ghes_edac: Improve driver's printk messages

 drivers/acpi/apei/ghes.c     |  64 +++------
 drivers/edac/Kconfig         |  23 ++++
 drivers/edac/Makefile        |   1 +
 drivers/edac/edac_core.h     |  17 +++
 drivers/edac/edac_mc.c       | 136 ++++++++++++++-----
 drivers/edac/edac_mc_sysfs.c |   7 +-
 drivers/edac/edac_module.c   |   2 +-
 drivers/edac/ghes_edac.c     | 313 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/ghes.h          |  72 ++++++++++
 include/linux/edac.h         |   5 +
 10 files changed, 560 insertions(+), 80 deletions(-)
 create mode 100644 drivers/edac/ghes_edac.c
 create mode 100644 include/acpi/ghes.h

-- 
1.8.1.2

