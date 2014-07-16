Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979AbaGPSXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:23:40 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:39178 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbaGPSXh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:23:37 -0400
From: Arvind Kumar <arvindkumar@vmware.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v2 RESEND 23/23] vmw_pvscsi: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Topic: [PATCH v2 RESEND 23/23] vmw_pvscsi: Use
 pci_enable_msix_exact() instead of pci_enable_msix()
Thread-Index: AQHPoSKZ7lahRUoP9UiUU1/ty2TqtZujA54J
Date: Wed, 16 Jul 2014 18:23:23 +0000
Message-ID: <9424d275bdc34133a03a68877ab253d0@EX13-MBX-025.vmware.com>
References: <cover.1405533479.git.agordeev@redhat.com>,<c27a72eaa07631ca182bfdb71d0d3d7f9f280b26.1405533479.git.agordeev@redhat.com>
In-Reply-To: <c27a72eaa07631ca182bfdb71d0d3d7f9f280b26.1405533479.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.113.160.246]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

This looks fine to me.

Acked-by: Arvind Kumar <arvindkumar@vmware.com>

Thanks!
Arvind
________________________________________
From: Alexander Gordeev <agordeev@redhat.com>
Sent: Wednesday, July 16, 2014 11:05 AM
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev; Arvind Kumar; pv-drivers@vmware.com; linux-scsi@vger.kernel.org; linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 23/23] vmw_pvscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>
Cc: pv-drivers@vmware.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Arvind Kumar <arvindkumar@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c88e146..598f65e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1194,7 +1194,7 @@ static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
        struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
        int ret;

-       ret = pci_enable_msix(adapter->dev, &entry, 1);
+       ret = pci_enable_msix_exact(adapter->dev, &entry, 1);
        if (ret)
                return ret;

--
1.7.7.6
