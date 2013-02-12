Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919Ab3BLAIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:08:41 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:48464 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679Ab3BLAIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:08:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130211224142.GA9782@google.com>
References: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org>
	<1360466060.3703.15.camel@thor.lan>
	<1360506199.3461.5.camel@thor.lan>
	<CAE9FiQX0Jzqi=Dy=r3MoU9vK7HgAf+919LvbgLygW7VH3O4=bg@mail.gmail.com>
	<CAE9FiQX5wQ8zFzPfgmvm0BESyLVxzDRQ33XPgj+QjBZ0kxuHXg@mail.gmail.com>
	<1360587768.3454.2.camel@thor.lan>
	<CAE9FiQWUZ3BgLOtcGePppLzWBv-uR8L+7abditH2MNA7zZW-WA@mail.gmail.com>
	<CAE9FiQXcgxY_vW6gjqU7Jtxc71J=sKt_2SPsN8x1O9EfDRN_0g@mail.gmail.com>
	<CAE9FiQXnb-op9vsQJroMisDQt_-X2UpBB1R_WJ1Lifnk5pPpGg@mail.gmail.com>
	<20130211224142.GA9782@google.com>
Date: Mon, 11 Feb 2013 16:08:38 -0800
X-Google-Sender-Auth: 28EICY7jGc9YMg4IhoOFeIcsR1k
Message-ID: <CAE9FiQUnrc1NxL-X9Ddj-Y6jv_+EdDLKaLzY_eo3VNsSq5XpDA@mail.gmail.com>
Subject: Re: [Bisected] [-next-20130204] usb/hcd: irq 18: nobody cared
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 2:41 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc linux-acpi, linux-pci]
>
> The _PRT describes motherboard interrupt wiring, which has nothing to
> do with PCI bus numbers.  Our current drivers/acpi/pci_irq.c caches
> the PCI bus number along with the _PRT, and I think that's a mistake.
>
> The bus number binding means acpi_pci_irq_add_prt() has to happen
> after enumerating everything below a bridge, and it will prevent us
> from doing any bus number reassignment for hotplug.
>
> I think we should remove the bus numbers from the cached _PRT (or
> maybe even remove the _PRT caching completely).  When we enable a PCI
> device's IRQ, we should search up the PCI device tree looking for a
> _PRT associated with each node, and applying normal PCI bridge
> swizzling when we don't find a _PRT.  I think this can be done without
> using PCI bus numbers at all.
>

Agreed, will give it try to remove the _PRT caching completely.

Thanks

Yinghai
