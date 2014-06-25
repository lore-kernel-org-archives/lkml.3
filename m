Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaFYJoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:44:08 -0400
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:44036 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaFYJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:44:03 -0400
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
References: <1401628118-17506-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401628118-17506-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFwhxc7uR170MyOFvBWG30Fh7P7mpw/pCLA
Date: Wed, 25 Jun 2014 15:11:42 +0530
Message-ID: <00b63b2641dfe04aef4feb003e98d63c@mail.gmail.com>
Subject: RE: [PATCH] scsi: mpt3sas: mpt3sas_transport.c: Cleaning up
 uninitialized variables
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

This Patch seem to be fine. Please consider this patch as Acked-by:
Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Regards,
Sreekanth

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Rickard Strandqvist
>Sent: Sunday, June 01, 2014 6:39 PM
>To: Nagalakshmi Nandigama; Sreekanth Reddy
>Cc: Rickard Strandqvist; support@lsi.com; James E.J. Bottomley; DL-
>MPTFusionLinux@lsi.com; linux-scsi@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: [PATCH] scsi: mpt3sas: mpt3sas_transport.c: Cleaning up
uninitialized
>variables
>
>There is a risk that the variable will be used without being initialized.
>
>This was largely found by using a static code analysis program called
cppcheck.
>
>Signed-off-by: Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se>
>---
> drivers/scsi/mpt3sas/mpt3sas_transport.c |    6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c
>b/drivers/scsi/mpt3sas/mpt3sas_transport.c
>index 65170cb..f648dc4 100644
>--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
>+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
>@@ -305,8 +305,8 @@ _transport_expander_report_manufacture(struct
>MPT3SAS_ADAPTER *ioc,
> 	void *data_out = NULL;
> 	dma_addr_t data_out_dma;
> 	dma_addr_t data_in_dma;
>-	size_t data_in_sz;
>-	size_t data_out_sz;
>+	size_t data_in_sz = sizeof(struct rep_manu_reply);
>+	size_t data_out_sz = sizeof(struct rep_manu_request);
> 	u16 wait_state_count;
>
> 	if (ioc->shost_recovery || ioc->pci_error_recovery) { @@ -357,8
>+357,6 @@ _transport_expander_report_manufacture(struct
>MPT3SAS_ADAPTER *ioc,
> 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
> 	ioc->transport_cmds.smid = smid;
>
>-	data_out_sz = sizeof(struct rep_manu_request);
>-	data_in_sz = sizeof(struct rep_manu_reply);
> 	data_out = pci_alloc_consistent(ioc->pdev, data_out_sz +
data_in_sz,
> 	    &data_out_dma);
>
>--
>1.7.10.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body
>of a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html
