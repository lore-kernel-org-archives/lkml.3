Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaBFO0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:26:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:64420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbaBFO0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:26:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="476986346"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        intel-linux-scu <intel-linux-scu@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
Subject: RE: [PATCH 10/22] isci: Use pci_enable_msix_range()
Thread-Topic: [PATCH 10/22] isci: Use pci_enable_msix_range()
Thread-Index: AQHPIZqCU9rXZ1v8f0OZ8A3K/z5yPpqoSh8w
Date: Thu, 6 Feb 2014 14:25:13 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6C7012@IRSMSX105.ger.corp.intel.com>
References: <cover.1391512266.git.agordeev@redhat.com>
 <ff99281291c3189da00a7d8150da326808a723ea.1391512266.git.agordeev@redhat.com>
In-Reply-To: <ff99281291c3189da00a7d8150da326808a723ea.1391512266.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 04, 2014 12:17 PM Alexander Gordeev <agordeev@redhat.com> wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Lukasz Dorau <lukasz.dorau@intel.com>
> Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: intel-linux-scu@intel.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/isci/init.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index d25d0d8..b99f307 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -356,8 +356,9 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
>  	for (i = 0; i < num_msix; i++)
>  		pci_info->msix_entries[i].entry = i;
> 
> -	err = pci_enable_msix(pdev, pci_info->msix_entries, num_msix);
> -	if (err)
> +	err = pci_enable_msix_range(pdev,
> +				    pci_info->msix_entries, num_msix, num_msix);
> +	if (err < 0)
>  		goto intx;
> 
>  	for (i = 0; i < num_msix; i++) {
> --
> 1.7.7.6

Looks fine.

Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>

Thanks,
Lukasz

