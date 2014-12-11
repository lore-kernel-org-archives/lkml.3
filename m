Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaLKL6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:58:42 -0500
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:54634 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaLKL6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:58:40 -0500
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402959408BB5@G4W3202.americas.hpqcorp.net>
References: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<94D0CD8314A33A4D9D801C0FE68B402959408BB5@G4W3202.americas.hpqcorp.net>
Date: Thu, 11 Dec 2014 17:28:37 +0530
Message-ID: <CAK=zhgpJ353oA3xiHatQ61tEZwrs09wcUsWBCb0bsYaWvVaMqw@mail.gmail.com>
Subject: Re: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu
 affinity for each MSIX vector enabled by the HBA
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@kernel.org" <jejb@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@parallels.com>,
        "Sathya.Prakash@avagotech.com" <Sathya.Prakash@avagotech.com>,
        "Nagalakshmi.Nandigama@avagotech.com" 
	<Nagalakshmi.Nandigama@avagotech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1609,6 +1611,10 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8
>> index, u32 vector)
>>       reply_q->ioc = ioc;
>>       reply_q->msix_index = index;
>>       reply_q->vector = vector;
>> +
>> +     if (!zalloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
>> +             return -ENOMEM;
>
> I think this will create the problem Alex Thorlton just reported
> with lpfc on a system with a huge number (6144) of CPUs.
>
> See this thread:
>         [BUG] kzalloc overflow in lpfc driver on 6k core system

Oh ok, Then I will use alloc_cpumask_var() API and cpumask_clear() to
initialize all the CPU bits in the mask to zero. Is it fine?

Regards,
Sreekanth
