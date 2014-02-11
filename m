Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750869AbaBKFKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 00:10:35 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:9006 "EHLO
	alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaBKFKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 00:10:33 -0500
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2014 00:10:32 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwFAG+t+VKtJXG9/2dsb2JhbABZgwyBD75kgRAWdIImAQEEJxM/EAIBCA4oEDIlAgQBDQWIBcl+F45wB4Q4AQOYKopOh1KDLYIq
X-IronPort-AV: E=Sophos;i="4.95,823,1384300800"; 
   d="scan'208";a="19456580"
From: "Suma Ramars (sramars)" <sramars@cisco.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Brian Uchino (buchino)" <buchino@cisco.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 07/22] fnic: Use pci_enable_msix_range()
Thread-Topic: [PATCH 07/22] fnic: Use pci_enable_msix_range()
Thread-Index: AQHPIZpwUuYz/FpPW0CbWHDKot9hHZqwSg8A
Date: Tue, 11 Feb 2014 05:00:56 +0000
Message-ID: <CF1FAC07.820C%sramars@cisco.com>
References: <cover.1391512266.git.agordeev@redhat.com>
 <01c54a9cf2e52395c59bd663766c8d1071da0a33.1391512266.git.agordeev@redhat.com>
In-Reply-To: <01c54a9cf2e52395c59bd663766c8d1071da0a33.1391512266.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [173.39.24.78]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FB883B43E8C43943A343F7BBA3A0D44C@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander

The changes look good to me. Thanks for taking care of this

-Suma

On 04/02/14 4:46 PM, "Alexander Gordeev" <agordeev@redhat.com> wrote:

>As result of deprecation of MSI-X/MSI enablement functions
>pci_enable_msix() and pci_enable_msi_block() all drivers
>using these two interfaces need to be updated to use the
>new pci_enable_msi_range() and pci_enable_msix_range()
>interfaces.
>
>Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>Cc: Hiral Patel <hiralpat@cisco.com>
>Cc: Suma Ramars <sramars@cisco.com>
>Cc: Brian Uchino <buchino@cisco.com>
>Cc: linux-scsi@vger.kernel.org
>Cc: linux-pci@vger.kernel.org
>---
> drivers/scsi/fnic/fnic_isr.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
>index 7d9b54a..0031c3e 100644
>--- a/drivers/scsi/fnic/fnic_isr.c
>+++ b/drivers/scsi/fnic/fnic_isr.c
>@@ -257,8 +257,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
> 	    fnic->raw_wq_count >= m &&
> 	    fnic->wq_copy_count >= o &&
> 	    fnic->cq_count >= n + m + o) {
>-		if (!pci_enable_msix(fnic->pdev, fnic->msix_entry,
>-				    n + m + o + 1)) {
>+		if (pci_enable_msix_range(fnic->pdev, fnic->msix_entry,
>+				          n + m + o + 1, n + m + o + 1) > 0) {
> 			fnic->rq_count = n;
> 			fnic->raw_wq_count = m;
> 			fnic->wq_copy_count = o;
>-- 
>1.7.7.6
>

