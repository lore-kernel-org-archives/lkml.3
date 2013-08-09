Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030924Ab3HITv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:51:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46253 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030877Ab3HITvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:51:24 -0400
Message-ID: <520547FB.5080706@infradead.org>
Date: Fri, 09 Aug 2013 12:50:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci <linux-pci@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 8 (not CONFIG_PCI_MSI conflict)
References: <20130808170822.82bf33d3cf5100f5e2646815@canb.auug.org.au> <5203F978.2050504@infradead.org> <20130809145939.GE25111@titan.lakedaemon.net> <52051BC2.2060004@infradead.org> <20130809185036.GG25111@titan.lakedaemon.net>
In-Reply-To: <20130809185036.GG25111@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/13 11:50, Jason Cooper wrote:
> Randy,
> 
> On Fri, Aug 09, 2013 at 09:41:38AM -0700, Randy Dunlap wrote:
>> On 08/09/13 07:59, Jason Cooper wrote:
>>> Randy,
>>>
>>> On Thu, Aug 08, 2013 at 01:03:04PM -0700, Randy Dunlap wrote:
>>>> On 08/08/13 00:08, Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> Changes since 20130807:
>>>>>
>>>>
>>>> on i386 and x86_64:
>>>> when CONFIG_PCI_MSI is not enabled:
>>>>
>>>> There are many of these errors:
>>>> include/linux/msi.h:65:6: error: expected identifier or '(' before 'void'
>>>> include/linux/msi.h:65:6: error: expected ')' before numeric constant
>>>>
>>>> because arch/x86/include/asm/pci.h defines:
>>>> #define default_teardown_msi_irqs	NULL
>>>
>>> Do you have an example config you used?
>>
>> Sure, attached. (or I have 14 of them)
> 
> Thanks, I was able to reproduce the error.  I'm not real familiar with
> this area of the code, but the relief is it doesn't appear to be caused
> by the mvebu changes (well, relief for us ;-) ).
> 
> At any rate, give this a spin and see if it works for you
> 
> If it's acceptable, I'll do an official patch for Bjorn.

Works for me -- tested with PCI_MSI enabled & disabled.
Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> thx,
> 
> Jason.
> 
> ---------->8----------
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> index d9e9e6c..6169414 100644
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -138,8 +138,8 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq);
>  #else
>  #define native_setup_msi_irqs		NULL
>  #define native_teardown_msi_irq		NULL
> -#define default_teardown_msi_irqs	NULL
> -#define default_restore_msi_irqs	NULL
> +void __weak default_teardown_msi_irqs(struct pci_dev *dev) { }
> +void __weak default_restore_msi_irqs(struct pci_dev *dev, int irq) { }
>  #endif
>  
>  #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
> --


-- 
~Randy
