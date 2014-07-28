Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaG1Lr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:47:27 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:65319 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbaG1LrY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:47:24 -0400
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 RESEND 22/23] qla4xxx: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Topic: [PATCH v2 RESEND 22/23] qla4xxx: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Index: AQHPoSCIRrAupA41eUmdqiyexhrgOJuyjesAgAO0tgA=
Date: Mon, 28 Jul 2014 11:47:19 +0000
Message-ID: <3FC4AB8B47ECD546BCD4B361A64BEACD8C6CAFD2@avmb3.qlogic.org>
References: <cover.1405533479.git.agordeev@redhat.com>
 <0496ccbc0f203afaeeb7758c146b93c2f387684c.1405533479.git.agordeev@redhat.com>
 <20140726084137.GL21129@agordeev.usersys.redhat.com>
In-Reply-To: <20140726084137.GL21129@agordeev.usersys.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B054D59BA2FE44BB231781055ED7A29@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7512 signatures=670489
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407280135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-By: Vikas Chaudhary <vikas.chaudhary@qlogic.com>



On 26/07/14 2:11 pm, "Alexander Gordeev" <agordeev@redhat.com> wrote:

>On Wed, Jul 16, 2014 at 08:05:26PM +0200, Alexander Gordeev wrote:
>> As result of deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range()  or pci_enable_msi_exact()
>> and pci_enable_msix_range() or pci_enable_msix_exact()
>> interfaces.
>
>Hi Vikas,
>
>Could you please reveiw this patch?
>
>Thanks!
>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>> Cc: iscsi-driver@qlogic.com
>> Cc: linux-scsi@vger.kernel.org
>> Cc: linux-pci@vger.kernel.org
>> Acked-By: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>> ---
>>  drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/scsi/qla4xxx/ql4_nx.c
>>b/drivers/scsi/qla4xxx/ql4_nx.c
>> index 9dbdb4b..7c33658 100644
>> --- a/drivers/scsi/qla4xxx/ql4_nx.c
>> +++ b/drivers/scsi/qla4xxx/ql4_nx.c
>> @@ -4221,7 +4221,7 @@ qla4_8xxx_enable_msix(struct scsi_qla_host *ha)
>>  	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
>>  		entries[i].entry = qla4_8xxx_msix_entries[i].entry;
>>  
>> -	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
>> +	ret = pci_enable_msix_exact(ha->pdev, entries, ARRAY_SIZE(entries));
>>  	if (ret) {
>>  		ql4_printk(KERN_WARNING, ha,
>>  		    "MSI-X: Failed to enable support -- %d/%d\n",
>> -- 
>> 1.7.7.6
>> 
>
>-- 
>Regards,
>Alexander Gordeev
>agordeev@redhat.com

