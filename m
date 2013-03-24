Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3CXLG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 07:06:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43171 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3CXLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 07:06:54 -0400
Date: Sun, 24 Mar 2013 12:06:49 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] PCI: Introduce MSI chip infrastructure
Message-ID: <20130324120649.6fb8c05d@skate>
In-Reply-To: <20130322093027.GA521@arm.com>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
	<20130322093027.GA521@arm.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Thierry,

On Fri, 22 Mar 2013 09:30:27 +0000, Andrew Murray wrote:

> I think this could work well. In the future if the use of an independent MSI
> controller is required, then new DT bindings for host-bridges could use
> phandles to reference independent MSI controllers as their providers of
> MSIs. I guess this functionality can be built on top of what you have proposed
> later as the need arises.

On Marvell HW (at least Armada 370/XP), MSIs are handled by the
main interrupt controller directly, or more precisely, managing the
MSIs requires fiddling with registers that are part of the interrupt
controller registers, and not part of the PCIe controller registers.

Basically, when a MSI interrupt is raised, it corresponds to IRQ 1 on
the main interrupt controller. Then, one has to read a register of the
main interrupt controller to find out which MSI interrupt was actually
triggered. So in our case, the MSI irq_chip really belongs to the
interrupt controller driver, and not the PCIe driver. Also, the
physical address to be added in the 'struct msi_msg' is the physical
address of an interrupt controller register.

Therefore, I'm not sure how to do the interaction between the PCIe
driver and the interrupt controller driver.

Suggestions?

I'll try to post some ugly code next week just to show what is
happening.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
