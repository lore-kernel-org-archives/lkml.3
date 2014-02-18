Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaBRIhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 03:37:13 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:28738 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbaBRIhJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 03:37:09 -0500
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 21/22] qla4xxx: Use pci_enable_msix_range()
Thread-Topic: [PATCH 21/22] qla4xxx: Use pci_enable_msix_range()
Thread-Index: AQHPIZp/AJLcU4fxf0SEEpoSJjtv75q7qEqA
Date: Tue, 18 Feb 2014 08:37:05 +0000
Message-ID: <3FC4AB8B47ECD546BCD4B361A64BEACD8C64E701@avmb3.qlogic.org>
References: <cover.1391512266.git.agordeev@redhat.com>
 <eb9c6c476786ff901512e46859f0d59a5e62170d.1391512266.git.agordeev@redhat.com>
In-Reply-To: <eb9c6c476786ff901512e46859f0d59a5e62170d.1391512266.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <99113A8B646FA54AAC94F583A3CA15E7@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7352 signatures=668936
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1402180005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/02/14 3:17 AM, "Alexander Gordeev" <agordeev@redhat.com> wrote:

>As result of deprecation of MSI-X/MSI enablement functions
>pci_enable_msix() and pci_enable_msi_block() all drivers
>using these two interfaces need to be updated to use the
>new pci_enable_msi_range() and pci_enable_msix_range()
>interfaces.
>
>Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>Cc: iscsi-driver@qlogic.com
>Cc: linux-scsi@vger.kernel.org
>Cc: linux-pci@vger.kernel.org
>---
> drivers/scsi/qla4xxx/ql4_nx.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
>index d001202..7f5412d 100644
>--- a/drivers/scsi/qla4xxx/ql4_nx.c
>+++ b/drivers/scsi/qla4xxx/ql4_nx.c
>@@ -3805,8 +3805,9 @@ qla4_8xxx_enable_msix(struct scsi_qla_host *ha)
> 	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
> 		entries[i].entry = qla4_8xxx_msix_entries[i].entry;
> 
>-	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
>-	if (ret) {
>+	ret = pci_enable_msix_range(ha->pdev, entries,
>+				    ARRAY_SIZE(entries), ARRAY_SIZE(entries));
>+	if (ret < 0) {
> 		ql4_printk(KERN_WARNING, ha,
> 		    "MSI-X: Failed to enable support -- %d/%d\n",
> 		    QLA_MSIX_ENTRIES, ret);

Looks good to me.
Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

