Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3FJXnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:43:13 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45039 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3FJXnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130609153123.GD2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
	<1370644273-10495-8-git-send-email-yinghai@kernel.org>
	<20130609153123.GD2245@breakpoint.cc>
Date: Mon, 10 Jun 2013 16:43:10 -0700
X-Google-Sender-Auth: upJzn5cu-o1nd21VJswy2Mxm7A0
Message-ID: <CAE9FiQU3FcuVUx5ZaOJWM+2cCakLThAXWzGopDKm88HFGW2i+Q@mail.gmail.com>
Subject: Re: [PATCH v3 07/27] iommu, irq: Allocate irq_desc for dmar_msi with
 local node
From: Yinghai Lu <yinghai@kernel.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Donald Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 8:31 AM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On Fri, Jun 07, 2013 at 03:30:53PM -0700, Yinghai Lu wrote:
>> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
>> index a7967ce..c09e60d 100644
>> --- a/drivers/iommu/dmar.c
>> +++ b/drivers/iommu/dmar.c
>> @@ -1273,7 +1273,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
>>       if (iommu->irq)
>>               return 0;
>>
>> -     irq = create_irq();
>> +     irq = create_irq_nr(0, iommu->node);
>>       if (!irq) {
>
> This is okay. However you fix a bug here so you might want first fix the bug
> with a Cc: stable tag and then do this.

ok, will add cc to stable to two related patches.

Thanks

Yinghai
