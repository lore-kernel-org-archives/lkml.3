Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3FJTlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3FJTlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:41:46 -0400
Date: Mon, 10 Jun 2013 21:42:59 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 10/27] genirq: Split __irq_reserve_irqs from
 irq_alloc_descs
Message-ID: <20130610194256.GA17507@dhcp-26-207.brq.redhat.com>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
 <1370644273-10495-11-git-send-email-yinghai@kernel.org>
 <20130610135154.GA11905@dhcp-26-207.brq.redhat.com>
 <CAE9FiQUvmyUt048veb_kFr-9Ap2cza7ti28x-cm9AcoU8edhbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUvmyUt048veb_kFr-9Ap2cza7ti28x-cm9AcoU8edhbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 12:16:16PM -0700, Yinghai Lu wrote:
> On Mon, Jun 10, 2013 at 6:51 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> >> +/**
> >> + * irq_alloc_descs - allocate and initialize a range of irq descriptors
> >> + * @irq:     Allocate for specific irq number if irq >= 0
> >> + * @from:    Start the search from this irq number
> >> + * @cnt:     Number of consecutive irqs to allocate.
> >> + * @node:    Preferred node on which the irq descriptor should be allocated
> >> + * @owner:   Owning module (can be NULL)
> >> + *
> >> + * Returns the first irq number or error code
> >> + */
> >> +int __ref
> >> +__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
> >> +               struct module *owner)
> >> +{
> >> +     int start;
> >> +
> >> +     start = __irq_reserve_irqs(irq, from, cnt);
> >> +
> >> +     if (start < 0)
> >> +             return start;
> >> +
> >> +     return alloc_descs(start, cnt, node, owner);
> >
> > I think alloc_descs() fail path is needed before return.
> 
> __irq_reserve_irqs already return -EEXIST etc,
> 
> old kernel is like:
> 
> >> @@ -380,12 +377,36 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
> 
>        bitmap_set(allocated_irqs, start, cnt);
>        mutex_unlock(&sparse_irq_lock);
>      return alloc_descs(start, cnt, node, owner);
> 
>  err:
>       mutex_unlock(&sparse_irq_lock);
>       return ret;
> 
> so i don't change the fail path handling.

I rather meant the bits should be unset in case alloc_descs() failed.
But I failed to notice alloc_descs() does it. Therefore..

Reviewed-by: Alexander Gordeev <agordeev@redhat.com>

> Thanks
> 
> Yinghai

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
