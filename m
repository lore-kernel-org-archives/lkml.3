Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaEOSUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:20:49 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56128 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaEOSUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:20:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware core driver
Date: Thu, 15 May 2014 20:20:13 +0200
Message-ID: <22200719.Jb5jnJylJH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5374FD24.8000806@ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <6048322.x3M3sdDEWO@wuerfel> <5374FD24.8000806@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Z+CzB5nFjBuVE7jQ2mUwcMLPtMmAQeuEE+yenTdC6bg
 c6OFTxA7vC7WPoklSRd2l6iOTeMq5Ts0ovL3safvyAA4t+KsIN
 foUBOTFuRw/vAtOE08jSRWM3R6hgqaaMWJ2gzWNbvC0O4j1Y++
 0NVV/Ir/1vFQkxjyNtD+i4cfv7J0OHYiYfgdNSiLJu5s+od9OA
 0cx/y3aBdafwsuPGWPvEPfiAClAonvMbUyMKSnVCkIGm1s6mgf
 0kOyDo0RvrftePgMqB1B2ROOUEssIziU3ZEi15l1WUpA9T24yB
 uEX4fNvdj0OEe42fR75bVWc8mBcy+bk0TzwhDH4YIV9fD0RIk0
 O+8SvQNIacRMQZzDmaeI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 13:45:08 Murali Karicheri wrote:
> >> +#ifdef CONFIG_PCI_KEYSTONE
> >> +/*
> >> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
> >> + */
> >> +static void quirk_limit_readrequest(struct pci_dev *dev)
> >> +{
> >> +    int readrq = pcie_get_readrq(dev);
> >> +
> >> +    if (readrq > 256)
> >> +            pcie_set_readrq(dev, 256);
> >> +}
> >> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
> >> +#endif /* CONFIG_PCI_KEYSTONE */
> > This doesn't work: you can't just limit do this for all devices just based
> > on PCI_KEYSTONE being enabled, you have to check if you are actually using
> > this controller.
> >
> >       Arnd
>   I assume, I need to check if PCI controller's vendor ID/ device ID 
> match with the keystone
>   PCI controller's ID and call pcie_set_readrq() for all of the slave 
> PCI devices and do this fixup.
> Is this correct understanding?  If you can point me to an example code 
> for this that will be
> really helpful so that I can avoid re-inventing the wheel.

I think it would be best to move the quirk into the keystone pci driver
and compare compare the dev->driver pointer of the PCI controller device.

	Arnd
