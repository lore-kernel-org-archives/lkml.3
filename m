Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3LBVpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:45:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3LBVow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:44:52 -0500
Date: Mon, 2 Dec 2013 13:44:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        Maximilian Attems <maks@stro.at>
Subject: Re: [PATCH] parport: parport_pc: remove double PCI ID for NetMos
Message-Id: <20131202134451.7568e6313c048f821defdbd6@linux-foundation.org>
In-Reply-To: <52971C5F.7040307@linutronix.de>
References: <1385570623-20260-1-git-send-email-bigeasy@linutronix.de>
	<20131127135322.49ea91c23db4879f97b524f0@linux-foundation.org>
	<52971C5F.7040307@linutronix.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013 11:35:11 +0100 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 11/27/2013 10:53 PM, Andrew Morton wrote:
> >> While here I also drop the entry for titan_1284p2 which is the same as
> >> netmos_9815.
> > 
> > Does this change have any runtime-visible effects?
> 
> Titan p2 used to specify class + subclass which is now replaced with
> PCI_ID_ANY, I doubt this makes any difference at all.
> 
> The only runtime visible change I notice is with KERN_DEBUG being
> visible. The card details are the same, it always prints
> 
> |parport1: PC-style at 0xc120 (0xc128), irq 11, using FIFO
> [PCSPP,TRISTATE,COMPAT,ECP]
> 
> However the ID that was used to detect the card is different:
> 
> | PCI parallel port detected: 1415:c118, I/O at 0xc120(0xc128), IRQ 11
> 
> vs
> 
> | PCI parallel port detected: 9710:9805, I/O at 0xc120(0xc128), IRQ 11
> 
> The wrong id print is printed for all devices which come after
> PCI_DEVICE_ID_OXSEMI_PCIe840_G in the id table because the code that
> prints the ID table assumes one id per entry.
> 
> So we could
> - drop printk
> - use id->vendor + id->device instead
> - do the last item + remove parport_pc_pci_cards and pass the data
>   struct as data.
> - nothing
> 
> any preferences?
> 

Well if the kernel is now printing the incorrect ID, we should fix
that.  The message should match the discovered hardware, and it should
match whatever `lspci' says is there.

