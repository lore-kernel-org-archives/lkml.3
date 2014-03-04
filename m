Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaCDT1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:27:48 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:48056 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754847AbaCDT1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:27:45 -0500
Date: Tue, 4 Mar 2014 11:27:44 -0800 (PST)
From: Arvind Kumar <arvindkumar@vmware.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Message-ID: <1412188603.36940054.1393961264565.JavaMail.root@vmware.com>
In-Reply-To: <a414d28c5587e57e78777a75c07873e1535dc839.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com> <a414d28c5587e57e78777a75c07873e1535dc839.1393191330.git.agordeev@redhat.com>
Subject: Re: [PATCH v2 23/23] vmw_pvscsi: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.68]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF26 (Linux)/8.0.3_GA_5664)
Thread-Topic: vmw_pvscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()
Thread-Index: NbRkHCe0N0jHGv6oT+qIPOqpPcdhig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

This looks fine to me.

Acked-by: Arvind Kumar <arvindkumar@vmware.com>

Thanks!
Arvind

----- Original Message -----
From: "Alexander Gordeev" <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Alexander Gordeev" <agordeev@redhat.com>, "Arvind Kumar" <arvindkumar@vmware.com>, pv-drivers@vmware.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Sent: Monday, February 24, 2014 12:02:23 AM
Subject: [PATCH v2 23/23] vmw_pvscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()

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
---
 drivers/scsi/vmw_pvscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index b9755ec..a046618 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1078,7 +1078,7 @@ static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
 	struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
 	int ret;
 
-	ret = pci_enable_msix(adapter->dev, &entry, 1);
+	ret = pci_enable_msix_exact(adapter->dev, &entry, 1);
 	if (ret)
 		return ret;
 
-- 
1.7.7.6
