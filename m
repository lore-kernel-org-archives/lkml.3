Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3I1NEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:04:20 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44128 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3I1NER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:04:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130928114950.GA2620@htj.dyndns.org>
References: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
	<20130928114950.GA2620@htj.dyndns.org>
Date: Sat, 28 Sep 2013 21:04:15 +0800
Message-ID: <CAP0P+NUvaLfXkOUGm8NX19AHvTHmU=Ya0NdFvyJc2gFjN-Cy0A@mail.gmail.com>
Subject: Re: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
From: xiangliang yu <yxlraid@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Tejun
i had tested the patch with Marvell 88se9235. And driver can find disk
if FBS disabled, or can't find disk.
Please see chapter 9.3.9 and 9.3.8 of AHCI spec. Thanks.


2013/9/28 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Sat, Sep 28, 2013 at 07:13:36PM +0800, Xiangliang Yu wrote:
>> If device is attached to port multiplier, the detection process
>> look like this:
>>       ahci_hardreset(link, class, deadline)
>>       if (class == ATA_DEV_PMP) {
>>               sata_pmp_attach(dev)    /* will enable FBS */
>>               sata_pmp_init_links(ap, nr_ports);
>>               ata_for_each_link(link, ap, EDGE) {
>>                       sata_std_hardreset(link, class, deadline);
>>                       if (link_is_online)
>>                               ahci_softreset(link, class, deadline);
>>               }
>>       }
>> But, according to chapter 9.3.9 in AHCI spec: Prior to issuing software reset,
>> software shall clear PxCMD.ST to '0' and then clear PxFBS.EN to '0'.
>
> How was this tested?  Do you observe any behavior difference?  At this
> point, we are not using SRST on PMP ports anyway, so I can't see how
> this would make any difference.
>
> Thanks.
>
> --
> tejun
