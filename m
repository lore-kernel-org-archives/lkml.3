Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaDYIsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:48:21 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:15627 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbaDYIsU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:48:20 -0400
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Dept-HSG Linux NIC Dev <Dept-HSGLinuxNICDev@qlogic.com>,
        netdev <netdev@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] qlcnic: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Topic: [PATCH net-next 2/2] qlcnic: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Index: AQHPYF0YARZHvVJuFEOYwJzqBE222ZsiA45A
Date: Fri, 25 Apr 2014 08:48:14 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46F9EE54@avmb2.qlogic.org>
References: <cover.1398412015.git.agordeev@redhat.com>
 <0a0d5f5c33d86e3777c22c3c1bbd81035660d57c.1398412015.git.agordeev@redhat.com>
In-Reply-To: <0a0d5f5c33d86e3777c22c3c1bbd81035660d57c.1398412015.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7418 signatures=670421
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1404250146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: Friday, April 25, 2014 1:36 PM
> To: linux-kernel
> Cc: Alexander Gordeev; Shahed Shaikh; Dept-HSG Linux NIC Dev; netdev;
> linux-pci
> Subject: [PATCH net-next 2/2] qlcnic: Use pci_enable_msix_exact() instead
> of pci_enable_msix()
> 
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers using these two
> interfaces need to be updated to use the new pci_enable_msi_range()  or
> pci_enable_msi_exact() and pci_enable_msix_range() or
> pci_enable_msix_exact() interfaces.
> 
> Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
> Cc: Dept-HSGLinuxNICDev@qlogic.com
> Cc: netdev@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> index dbf7539..26f022b 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> @@ -690,8 +690,8 @@ int qlcnic_setup_tss_rss_intr(struct qlcnic_adapter
> *adapter)
>  		adapter->msix_entries[vector].entry = vector;
> 
>  restore:
> -	err = pci_enable_msix(pdev, adapter->msix_entries, num_msix);
> -	if (err > 0) {
> +	err = pci_enable_msix_exact(pdev, adapter->msix_entries,
> num_msix);
> +	if (err == -ENOSPC) {
>  		if (!adapter->drv_tss_rings && !adapter->drv_rss_rings)
>  			return -ENOSPC;

I think, it would be good if we return "err" instead of "-ENOSPC" .
  
                if (!adapter->drv_tss_rings && !adapter->drv_rss_rings)
-                       return -ENOSPC;
+                       return err;

Thanks,
Shahed

