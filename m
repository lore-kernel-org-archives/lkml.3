Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaIXVBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:01:44 -0400
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:15097
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750767AbaIXVBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:01:43 -0400
X-Greylist: delayed 802 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 17:01:42 EDT
X-WSS-ID: 0NCFB09-08-8CG-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v4 00/23] AMDKFD Kernel Driver
Date: Wed, 24 Sep 2014 23:45:14 +0300
Message-ID: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(11905935001)(87936001)(62966002)(90102001)(229853001)(93916002)(87286001)(102836001)(92566001)(86362001)(104166001)(36756003)(48376002)(44976005)(50466002)(31966008)(76482002)(15395725005)(33646002)(99396003)(120916001)(10300001)(92726001)(95666004)(101416001)(74502003)(84676001)(97736003)(106466001)(105586002)(50226001)(77982003)(74662003)(81542003)(81342003)(4396001)(83072002)(47776003)(20776003)(50986999)(80022003)(88136002)(68736004)(19580395003)(21056001)(107046002)(15202345003)(89996001)(85306004)(64706001)(46102003)(77096002)(77156001)(79102003)(15975445006)(85852003)(83322001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0201MB1075;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB1075;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is the v4 patch set of amdkfd.

This version mainly contains fixes to the code published in v3 and changes to 
commit messages to reflect the fixes. In addition, I have added the latest 
version of a patch-set prepared by Joerg Roedel that allows the mm sub-system 
to handle TLBs which are external to the CPU (i.e handled by the IOMMU). 

The patch-set is rebased over latest drm-next (3.17-rc5) and 
radeon's drm-next-3.18. Therefore, I removed some mm and IOMMU patches that 
were part of my tree in v3 as they are already merged into kernel 3.17

For people who like to review using git, the v4 patch set is located at:
http://cgit.freedesktop.org/~gabbayo/linux/?h=amdkfd-v4

Link to v3 cover letter: 
http://lwn.net/Articles/607730/

Link to v2 cover letter: 
http://lists.freedesktop.org/archives/dri-devel/2014-July/064011.html

Link to v1 cover letter: 
http://lwn.net/Articles/605153/

Any comment / review is appreciated.

	- Oded

Alexey Skidanov (1):
  amdkfd: Implement the Get Process Aperture IOCTL

Andrew Lewycky (3):
  amdkfd: Add basic modules to amdkfd
  amdkfd: Add interrupt handling module
  amdkfd: Implement the Set Memory Policy IOCTL

Ben Goz (8):
  amdkfd: Add queue module
  amdkfd: Add mqd_manager module
  amdkfd: Add kernel queue module
  amdkfd: Add module parameter of scheduling policy
  amdkfd: Add packet manager module
  amdkfd: Add process queue manager module
  amdkfd: Add device queue manager module
  amdkfd: Implement the create/destroy/update queue IOCTLs

Evgeny Pinchuk (2):
  amdkfd: Add topology module to amdkfd
  amdkfd: Implement the Get Clock Counters IOCTL

Oded Gabbay (9):
  drm/radeon: reduce number of free VMIDs and pipes in KV
  drm/radeon/cik: Don't touch int of pipes 1-7
  drm/radeon: Report doorbell configuration to amdkfd
  drm/radeon: adding synchronization for GRBM GFX
  drm/radeon: Add radeon <--> amdkfd interface
  Update MAINTAINERS and CREDITS files with amdkfd info
  amdkfd: Add IOCTL set definitions of amdkfd
  amdkfd: Add amdkfd skeleton driver
  amdkfd: Add binding/unbinding calls to amd_iommu driver

 CREDITS                                            |    7 +
 MAINTAINERS                                        |   10 +
 drivers/gpu/drm/radeon/Kconfig                     |    2 +
 drivers/gpu/drm/radeon/Makefile                    |    3 +
 drivers/gpu/drm/radeon/amdkfd/Kconfig              |   10 +
 drivers/gpu/drm/radeon/amdkfd/Makefile             |   14 +
 drivers/gpu/drm/radeon/amdkfd/cik_regs.h           |  221 ++++
 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c       |  350 ++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c        |  520 +++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_crat.h           |  294 +++++
 drivers/gpu/drm/radeon/amdkfd/kfd_device.c         |  300 +++++
 .../drm/radeon/amdkfd/kfd_device_queue_manager.c   |  995 ++++++++++++++++
 .../drm/radeon/amdkfd/kfd_device_queue_manager.h   |  144 +++
 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c       |  236 ++++
 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c      |  161 +++
 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c   |  330 ++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h   |   66 ++
 drivers/gpu/drm/radeon/amdkfd/kfd_module.c         |  147 +++
 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c    |  312 +++++
 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h    |   88 ++
 drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c |  495 ++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c          |   95 ++
 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h    |  682 +++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h    |  107 ++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  560 +++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_process.c        |  350 ++++++
 .../drm/radeon/amdkfd/kfd_process_queue_manager.c  |  353 ++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c          |   85 ++
 drivers/gpu/drm/radeon/amdkfd/kfd_topology.c       | 1207 ++++++++++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_topology.h       |  168 +++
 drivers/gpu/drm/radeon/cik.c                       |  154 +--
 drivers/gpu/drm/radeon/cik_reg.h                   |   65 ++
 drivers/gpu/drm/radeon/cikd.h                      |   53 +-
 drivers/gpu/drm/radeon/radeon.h                    |   10 +
 drivers/gpu/drm/radeon/radeon_device.c             |   32 +
 drivers/gpu/drm/radeon/radeon_drv.c                |    5 +
 drivers/gpu/drm/radeon/radeon_kfd.c                |  525 +++++++++
 drivers/gpu/drm/radeon/radeon_kfd.h                |  177 +++
 drivers/gpu/drm/radeon/radeon_kms.c                |    7 +
 include/uapi/linux/kfd_ioctl.h                     |  126 ++
 40 files changed, 9371 insertions(+), 95 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/Kconfig
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/Makefile
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/cik_regs.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_crat.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_module.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
 create mode 100644 include/uapi/linux/kfd_ioctl.h

-- 
1.9.1

