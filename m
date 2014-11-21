Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaKUVGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:06:49 -0500
Received: from mail-bn1bbn0107.outbound.protection.outlook.com ([157.56.111.107]:14689
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751097AbaKUVGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:06:48 -0500
X-WSS-ID: 0NFEQN3-08-1WU-02
X-M-MSG: 
Date: Fri, 21 Nov 2014 23:06:36 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
To: <airlied@gmail.com>
CC: <oded.gabbay@amd.com>, <John.Bridgman@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <alexander.deucher@amd.com>
Subject: [PULL] amdkfd-next-3.19
Message-ID: <20141121210636.GA10938@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377424004)(199003)(189002)(46406003)(97736003)(50466002)(68736004)(92566001)(86362001)(47776003)(20776003)(19580395003)(101416001)(99396003)(64706001)(120916001)(102836001)(95666004)(84676001)(92726001)(87936001)(33656002)(105586002)(2351001)(83506001)(107046002)(62966003)(77096003)(77156002)(31966008)(36756003)(230783001)(21056001)(54356999)(50986999)(97756001)(44976005)(106466001)(229853001)(23726002)(110136001)(4396001)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Forefront-PRVS: 0402872DA1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

first batch of amdkfd patches after initial merge. Highlights:

- Fixes for sparse warnings
- Memory leak fix
- Fix for deadlock between amdkfd and iommu

The following changes since commit ed1e8777a56f3523712506d608a29f57ed37b613:

  Merge branch 'drm-next-3.19' of git://people.freedesktop.org/~agd5f/linux into drm-next (2014-11-21 12:17:43 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~gabbayo/linux amdkfd-next-3.19

for you to fetch changes up to 48d7761d23d00ce40c70172727b802a9b5a54962:

  amdkfd: Remove DRM_AMDGPU dependency from Kconfig (2014-11-21 22:55:31 +0200)

----------------------------------------------------------------
Alexey Skidanov (1):
      amdkfd: Instead of using get function, use container_of

Jay Cornwall (1):
      amdkfd: Fix memory leak on process deregistration

Oded Gabbay (10):
      amdkfd: Fix sparse warnings in kfd_chardev.c
      amdkfd: Fix sparse warnings in kfd_topology.c
      amdkfd: Fix sparse warnings in kfd_flat_memory.c
      amdkfd: is_occupied() can be static
      amdkfd: fence_wait_timeout() can be static
      amdkfd: add __iomem attribute to doorbell_ptr
      amdkfd: use schedule() in sync_with_hw
      amdkfd: Clear ctx cb before suspend
      amdkfd: explicitely include io.h in kfd_doorbell.c
      amdkfd: Remove DRM_AMDGPU dependency from Kconfig

kbuild test robot (2):
      amdkfd: test_kq() can be static
      amdkfd: pqm_get_kernel_queue() can be static

 drivers/gpu/drm/amd/amdkfd/Kconfig                 |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           | 16 ++++++---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  1 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 27 +++++++--------
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |  1 +
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c       | 11 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c      | 14 ++++----
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |  6 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  4 ++-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          | 40 +++++++++++-----------
 11 files changed, 69 insertions(+), 56 deletions(-)
