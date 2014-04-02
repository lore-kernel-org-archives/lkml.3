Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaDBQrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:47:10 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:49736 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbaDBQrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:47:06 -0400
MIME-Version: 1.0
X-Originating-IP: [92.17.186.38]
In-Reply-To: <533C300E.7070109@ti.com>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
	<1395707726-20437-4-git-send-email-m-karicheri2@ti.com>
	<235376049.yyfljDtinu@wuerfel>
	<20140325103525.GA14789@ulmo>
	<CAPcvp5Gy8uNW3UULi8jYk7GNbmgTd2B_qOEAXnP4H4Wq3v9BCw@mail.gmail.com>
	<533C300E.7070109@ti.com>
Date: Wed, 2 Apr 2014 17:47:04 +0100
Message-ID: <CAPcvp5FEFbP_Fwc47V=LppiZnfbTgPqaAAm-A9K17dVEZWwHQQ@mail.gmail.com>
Subject: Re: [RESEND: RFC PATCH 3/3] pcie: keystone: add pcie driver based on
 designware core driver
From: Andrew Murray <amurray@embedded-bits.co.uk>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Richard Zhu <r65037@freescale.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 April 2014 16:43, Murali Karicheri <m-karicheri2@ti.com> wrote:

> Keystone pcie driver is developed based on other dw based pcie drivers
>
> such as pci-exynos that uses subsys_initcall(). I am new to this list,
>
> probably Jingoo (copied) has some history on why we can't use module.
> For now I will keep it as is and can be re-visited in the next revisions.
> Also I will experiment with PCIE port driver as well.
>
>
> BTW, PCIE driver currently uses Legacy or MSI IRQ. Keystone PCI has
> a platform IRQ. Is DT based irq configuration is the appropriate way
> to add this capability?

As far as I am aware - the PCI standards define a particular way for
devices to describe which interrupt will be used for things like
hotplug, AER and PME. These interrupts are always PCI interrupts (i.e.
MSI/MSI-X/legacy). Thus the port services code in the kernel uses
standard configuration space accesses to determine the interrupt to
use. Also note that it's not just the host bridge that can provide
these services but any PCIE device, I guess in this sense a host
bridge is treated like any other device.

If my understanding is correct I don't believe the current port
services code allows exceptions to this, i.e. to say this host bridge
actually uses a platform IRQ for AER rather than an MSI. Though this
may be quite useful as I suspect many host bridges provide interrupts
for things like PME through platform IRQs rather that PCI interrupts.

Does the Keystone have platform IRQs for things like AER? Is that
because the IP makes these events available through platform IRQs in
addition to the standard PCI means?

Andrew Murray
