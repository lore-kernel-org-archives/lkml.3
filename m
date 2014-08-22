Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbaHVOky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:40:54 -0400
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:58162 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbaHVOkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:40:52 -0400
From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
To: Tomas Henzl <thenzl@redhat.com>, Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v3 08/13] be2iscsi: Use pci_enable_msix_range()
Thread-Topic: [PATCH v3 08/13] be2iscsi: Use pci_enable_msix_range()
Thread-Index: AQHPuqoBt3Eq2WF7cE2CRar3E4nKOJvbYPyAgAFXboA=
Date: Fri, 22 Aug 2014 14:40:25 +0000
Message-ID: <37724B2049F71D4C9B086F99DDB2DE11572409D6@CMEXMB2.ad.emulex.com>
References: <cover.1408335523.git.agordeev@redhat.com>
 <1cf2c3d3243067edac8d170cda0450c82bbfc025.1408335523.git.agordeev@redhat.com>
 <53F5D397.2020508@redhat.com>
In-Reply-To: <53F5D397.2020508@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.125.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Thursday, August 21, 2014 4:10 AM
To: Alexander Gordeev; linux-kernel@vger.kernel.org
Cc: Jayamohan Kallickal; linux-scsi@vger.kernel.org; linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 08/13] be2iscsi: Use pci_enable_msix_range()

On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers using these 
> two interfaces need to be updated to use the new 
> pci_enable_msi_range() and pci_enable_msix_range() interfaces.

Patch looks good to me.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/be2iscsi/be_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c 
> b/drivers/scsi/be2iscsi/be_main.c index 915c26b..b422659 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5276,9 +5276,9 @@ static void beiscsi_msix_enable(struct beiscsi_hba *phba)
>  	for (i = 0; i <= phba->num_cpus; i++)
>  		phba->msix_entries[i].entry = i;
>  
> -	status = pci_enable_msix(phba->pcidev, phba->msix_entries,
> -				 (phba->num_cpus + 1));
> -	if (!status)
> +	status = pci_enable_msix_range(phba->pcidev, phba->msix_entries,
> +				       phba->num_cpus + 1, phba->num_cpus + 1);
> +	if (status > 0)
>  		phba->msix_enabled = true;
>  
>  	return;


Looks Good.

Acked-by:  Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
--
