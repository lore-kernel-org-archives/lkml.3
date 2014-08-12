Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaHLJvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:51:16 -0400
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:52670 "EHLO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaHLJvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:51:14 -0400
MIME-Version: 1.0
In-Reply-To: <1407836262.3141.16.camel@joe-AO725>
References: <1407835482-37919-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1407836262.3141.16.camel@joe-AO725>
Date: Tue, 12 Aug 2014 15:21:13 +0530
Message-ID: <CAK=zhgrvTVoy8zvu21U00NQV53LSiK8HRMTFAarRHJLXqRJRiw@mail.gmail.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post
 Queue (RDPQ) Array support
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
To: Joe Perches <joe@perches.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 3:07 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-08-12 at 14:54 +0530, Sreekanth Reddy wrote:
>> So, the proposal is to allocate memory independently for each
>> Reply Queue and pass down all of the addresses to the firmware.
>> Then the firmware will just take each address and program the value
>> into the correct register.
>
> trivial note:
>
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> []
>> @@ -1179,17 +1184,22 @@ static int
>>  _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
>>  {
>>       struct sysinfo s;
>> -     char *desc = NULL;
>> +     u64 consistent_dma_mask;
>> +
>> +     if (dma_mask)
>> +             consistent_dma_mask = DMA_BIT_MASK(64);
>> +     else
>> +             consistent_dma_mask = DMA_BIT_MASK(32);
>>
>>       if (sizeof(dma_addr_t) > 4) {
>>               const uint64_t required_mask =
>>                   dma_get_required_mask(&pdev->dev);
>>               if ((required_mask > DMA_BIT_MASK(32)) && !pci_set_dma_mask(pdev,
>>                   DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(pdev,
>> -                 DMA_BIT_MASK(64))) {
>> +                 consistent_dma_mask)) {
>
> This would be easier to read if the embedded functions
> within the if were on separate lines like:

Accepted. next time onwards I will take care of this.

>
>                 if ((required_mask > DMA_BIT_MASK(32)) &&
>                     !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
>                     !pci_set_consistent_dma_mask(pdev, consistent_dma_mask)) {
>
>
