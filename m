Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaG1ISJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:18:09 -0400
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:56962 "EHLO
	rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaG1ISF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:18:05 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2014 04:18:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUFAIgD1lOtJV2P/2dsb2JhbABZgw6BKQTTJAGBExZ3hAQBAQQnEz8QAgEIDgoeEDIlAgQBDQWIQr0jF49MB4RKAQSbTItyiFqCA4FGbIFF
X-IronPort-AV: E=Sophos;i="5.01,747,1400025600"; 
   d="scan'208";a="343066348"
From: "Suma Ramars (sramars)" <sramars@cisco.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Hiral Patel <hiralpat@cisco.com>,
        "Brian Uchino (buchino)" <buchino@cisco.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 RESEND 07/23] fnic: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Topic: [PATCH v2 RESEND 07/23] fnic: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Index: AQHPqKiOesDylc0bF0KO6oYo735Pkpu11OsA
Date: Mon, 28 Jul 2014 08:08:28 +0000
Message-ID: <CFFC0234.11596%sramars@cisco.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <e8cc7988e4b0a38f59d3e854d387c7c0d95b058c.1405533479.git.agordeev@redhat.com>
 <20140726081502.GD21129@agordeev.usersys.redhat.com>
In-Reply-To: <20140726081502.GD21129@agordeev.usersys.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.3.140616
x-originating-ip: [10.65.39.72]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75FDE10A4E1E384E847BCEFCBA1792C5@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: "Suma Ramars (sramars)" <sramars@cisco.com>


On 26/07/14 1:45 pm, "Alexander Gordeev" <agordeev@redhat.com> wrote:

>On Wed, Jul 16, 2014 at 08:05:11PM +0200, Alexander Gordeev wrote:
>> As result of deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range()  or pci_enable_msi_exact()
>> and pci_enable_msix_range() or pci_enable_msix_exact()
>> interfaces.
>
>Hi Hiral, Suma, Brian,
>
>Could you please review this patch?
>
>Thanks!
>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: Hiral Patel <hiralpat@cisco.com>
>> Cc: Suma Ramars <sramars@cisco.com>
>> Cc: Brian Uchino <buchino@cisco.com>
>> Cc: linux-scsi@vger.kernel.org
>> Cc: linux-pci@vger.kernel.org
>> ---
>>  drivers/scsi/fnic/fnic_isr.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
>> index 7d9b54a..a0dd1b6 100644
>> --- a/drivers/scsi/fnic/fnic_isr.c
>> +++ b/drivers/scsi/fnic/fnic_isr.c
>> @@ -257,8 +257,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
>>  	    fnic->raw_wq_count >= m &&
>>  	    fnic->wq_copy_count >= o &&
>>  	    fnic->cq_count >= n + m + o) {
>> -		if (!pci_enable_msix(fnic->pdev, fnic->msix_entry,
>> -				    n + m + o + 1)) {
>> +		if (!pci_enable_msix_exact(fnic->pdev, fnic->msix_entry,
>> +					   n + m + o + 1)) {
>>  			fnic->rq_count = n;
>>  			fnic->raw_wq_count = m;
>>  			fnic->wq_copy_count = o;
>> -- 
>> 1.7.7.6
>> 
>
>-- 
>Regards,
>Alexander Gordeev
>agordeev@redhat.com

