Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3CHTtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:49:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3CHTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:49:04 -0500
Date: Fri, 8 Mar 2013 14:48:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v2 09/26] x86, irq: kill create_irq()
Message-ID: <20130308194833.GC6622@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
 <1360351703-20571-10-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360351703-20571-10-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 11:28:06AM -0800, Yinghai Lu wrote:
> create_irq() will return -1 when fail to allocate.

.. failing to allocate
> create_irq_nr() will return 0 when fail to allocate.

.. failing..
> 
> It only causes confusing.

confusion.

> 
> Now we have no user for create_irq(), so remove create_irq() for x86.

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  arch/x86/kernel/apic/io_apic.c |   15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index c703092..4c1a726 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2968,21 +2968,6 @@ unsigned int create_irq_nr(unsigned int from, int node)
>  	return __create_irqs(from, 1, node);
>  }
>  
> -int create_irq(void)
> -{
> -	int node = cpu_to_node(0);
> -	unsigned int irq_want;
> -	int irq;
> -
> -	irq_want = nr_irqs_gsi;
> -	irq = create_irq_nr(irq_want, node);
> -
> -	if (irq == 0)
> -		irq = -1;
> -
> -	return irq;
> -}
> -
>  void destroy_irq(unsigned int irq)
>  {
>  	struct irq_cfg *cfg = irq_get_chip_data(irq);
> -- 
> 1.7.10.4
> 
