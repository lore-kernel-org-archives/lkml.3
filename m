Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaEGJqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:46:09 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:47859 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaEGJqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:46:07 -0400
Date: Wed, 7 May 2014 11:46:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] irq: core changes for x86 ioapic hotplug
Message-ID: <20140507094602.GA17560@gmail.com>
References: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Hi,
> 
> These patches are core changes for x86 ioapic hotplug support.
> 
> First part for kill old irq_reserve_irqs:
> During reviewing ioapic hotplug patchset, Thomas pointed out that
> should not extend irq_reserve_irq for that purpose as that is not
> actually reserve.
> Neet to clean up old irq_reserve_irq before introduce reserve/alloc_reserved
> method for ioapic hotplug.
> So here patchset that kill irq_reserve_irq that actually set allocated_irqs.
> First remove irq_reserve_irqs for x86, and remove irq_reserve_irq
> for sh.
> Then in set_irq_chip use irq_alloc_desc instead of irq_reserve_irq.
> Next will mark bits in allocated_irqs early for init irqs in !SPARSE_IRQ
> 
> Second parts are new reserve/alloc_reserved functions:
> It will introduce reserved_irqs bit maps to track reserved irqs.
> New irq_alloc_reserved_desc() will only allocate desc when that irq
> is reserved, at the same time irq_alloc_desc will only allocate desc
> when irq is not reserved.

That's not a proper description of the problem and the solution. The 
same problem of lack of proper explanation permeates most of your 
patches as well and that's very far from the quality threshold that 
core IRQ patches need to meet.

Crappy descriptions and passive-aggressive responses where you pretend 
you don't understand our complaints and just minimally address the 
problems are not acceptable.

So I concur with Thomas and this series earns a big fat NAK from me. 
(Please Cc: me to all (if any) future resubmissions so I can track 
progress (or the lack thereof) and see whether I can lift my NAK.)

Thanks,

	Ingo
