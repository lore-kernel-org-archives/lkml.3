Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3FRIrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:47:05 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61577 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3FRIrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:47:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130617132607.GA10671@intel.com>
References: <1370246529-17155-1-git-send-email-wangxfdu@gmail.com>
	<1370246529-17155-2-git-send-email-wangxfdu@gmail.com>
	<20130617132607.GA10671@intel.com>
Date: Tue, 18 Jun 2013 16:47:00 +0800
Message-ID: <CACDNBm3v1uW=ViC=ghfCx1a6EDFy1sJozntrKAzCQWmTzEoKWA@mail.gmail.com>
Subject: Re: [PATCH 1/2] dma: mmp_pdma: add protect when alloc/free phy channels
From: Xiang Wang <wangxfdu@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/17 Vinod Koul <vinod.koul@intel.com>:
> On Mon, Jun 03, 2013 at 04:02:08PM +0800, Xiang Wang wrote:
>> From: Xiang Wang <wangx@marvell.com>
>>
>> In mmp pdma, phy channels are allocated/freed dynamically
>> and frequently. But no proper protection is added.
>> Conflict will happen when multi-users are requesting phy
>> channels at the same time. Use spinlock to protect.
>>
>> Signed-off-by: Xiang Wang <wangx@marvell.com>
>> ---
>>  drivers/dma/mmp_pdma.c |   41 +++++++++++++++++++++++++----------------
>>  1 files changed, 25 insertions(+), 16 deletions(-)
>>
>
>> +static void free_phy(struct mmp_pdma_chan *pchan)
> pls namespace this
Updated in patch set V3. Thanks!
>> +{
>> +     struct mmp_pdma_device *pdev = to_mmp_pdma_dev(pchan->chan.device);
>> +     unsigned long flags;
> empty line pls
Updated in patch set V3. Thanks!
>
>> +     if (!pchan->phy)
>> +             return;
>> +
>> +     spin_lock_irqsave(&pdev->phy_lock, flags);
>> +     pchan->phy->vchan = NULL;
>> +     pchan->phy = NULL;
>> +     spin_unlock_irqrestore(&pdev->phy_lock, flags);
>> +}
>> +
> rest looks okay
>
> --
> ~Vinod



--
Regards,
Xiang
