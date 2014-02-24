Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaBXVie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:38:34 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38814 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaBXVic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:38:32 -0500
MIME-Version: 1.0
In-Reply-To: <21860356.103351393198399120.JavaMail.weblogic@epml01>
References: <21860356.103351393198399120.JavaMail.weblogic@epml01>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 24 Feb 2014 14:38:11 -0700
Message-ID: <CAErSpo5WW4=aL_BqhnrG+J1Xq=FVtdu0BWkHUyeiOrbBhqmYwg@mail.gmail.com>
Subject: Re: [patch 07/26] pci: pcie-designware: Remove irq_desc abuse
To: Jingoo Han <jg1.han@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mohit Kumar <mohit.kumar@st.com>, pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 4:33 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Monday, February 24, 2014 6:40 AM, Thomas Gleixner wrote:
>>
>> There is no reason to care about irq_desc in that context, escpecially
>> as irq_data for that interrupt is retrieved as well.
>>
>> Use the proper accessor for the msi descriptor
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> Cc: Mohit Kumar <mohit.kumar@st.com>
>> Cc: pci <linux-pci@vger.kernel.org>
>
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thomas, I assume you'll merge this along with the rest of your series.
 I don't have any pending changes in this area.

Bjorn

> A few days ago, I noticed that irq_data_get_msi() can be used.
> However, I did not submit the same patch. I really appreciate
> your patch. :-)
>
> Best regards,
> Jingoo Han
>
>> ---
>>  drivers/pci/host/pcie-designware.c |    4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> Index: tip/drivers/pci/host/pcie-designware.c
>> ===================================================================
>> --- tip.orig/drivers/pci/host/pcie-designware.c
>> +++ tip/drivers/pci/host/pcie-designware.c
>> @@ -294,14 +294,12 @@ no_valid_irq:
>>  static void clear_irq(unsigned int irq)
>>  {
>>       unsigned int pos, nvec;
>> -     struct irq_desc *desc;
>>       struct msi_desc *msi;
>>       struct pcie_port *pp;
>>       struct irq_data *data = irq_get_irq_data(irq);
>>
>>       /* get the port structure */
>> -     desc = irq_to_desc(irq);
>> -     msi = irq_desc_get_msi_desc(desc);
>> +     msi = irq_data_get_msi(data);
>>       pp = sys_to_pcie(msi->dev->bus->sysdata);
>>       if (!pp) {
>>               BUG();
