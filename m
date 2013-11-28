Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab3K1KfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:35:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:56607 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3K1KfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:35:14 -0500
Message-ID: <52971C5F.7040307@linutronix.de>
Date: Thu, 28 Nov 2013 11:35:11 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        Maximilian Attems <maks@stro.at>
Subject: Re: [PATCH] parport: parport_pc: remove double PCI ID for NetMos
References: <1385570623-20260-1-git-send-email-bigeasy@linutronix.de> <20131127135322.49ea91c23db4879f97b524f0@linux-foundation.org>
In-Reply-To: <20131127135322.49ea91c23db4879f97b524f0@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 10:53 PM, Andrew Morton wrote:
>> While here I also drop the entry for titan_1284p2 which is the same as
>> netmos_9815.
> 
> Does this change have any runtime-visible effects?

Titan p2 used to specify class + subclass which is now replaced with
PCI_ID_ANY, I doubt this makes any difference at all.

The only runtime visible change I notice is with KERN_DEBUG being
visible. The card details are the same, it always prints

|parport1: PC-style at 0xc120 (0xc128), irq 11, using FIFO
[PCSPP,TRISTATE,COMPAT,ECP]

However the ID that was used to detect the card is different:

| PCI parallel port detected: 1415:c118, I/O at 0xc120(0xc128), IRQ 11

vs

| PCI parallel port detected: 9710:9805, I/O at 0xc120(0xc128), IRQ 11

The wrong id print is printed for all devices which come after
PCI_DEVICE_ID_OXSEMI_PCIe840_G in the id table because the code that
prints the ID table assumes one id per entry.

So we could
- drop printk
- use id->vendor + id->device instead
- do the last item + remove parport_pc_pci_cards and pass the data
  struct as data.
- nothing

any preferences?

Sebastian
