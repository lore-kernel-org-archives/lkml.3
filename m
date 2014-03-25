Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaCYLqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 07:46:43 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:52963 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaCYLql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:46:41 -0400
MIME-Version: 1.0
X-Originating-IP: [92.17.186.38]
In-Reply-To: <20140325103525.GA14789@ulmo>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
	<1395707726-20437-4-git-send-email-m-karicheri2@ti.com>
	<235376049.yyfljDtinu@wuerfel>
	<20140325103525.GA14789@ulmo>
Date: Tue, 25 Mar 2014 11:46:41 +0000
Message-ID: <CAPcvp5Gy8uNW3UULi8jYk7GNbmgTd2B_qOEAXnP4H4Wq3v9BCw@mail.gmail.com>
Subject: Re: [RESEND: RFC PATCH 3/3] pcie: keystone: add pcie driver based on
 designware core driver
From: Andrew Murray <amurray@embedded-bits.co.uk>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Richard Zhu <r65037@freescale.com>, linux-samsung-soc@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2014 10:35, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Tue, Mar 25, 2014 at 08:44:36AM +0100, Arnd Bergmann wrote:
>> On Monday 24 March 2014 20:35:26 Murali Karicheri wrote:
> [...]
>> > +/* Keystone PCIe driver does not allow module unload */
>> > +static int __init ks_pcie_init(void)
>> > +{
>> > +   return platform_driver_probe(&ks_pcie_driver, ks_pcie_probe);
>> > +}
>> > +subsys_initcall(ks_pcie_init);
>>
>> Why subsys_initcall?
>>
>> We should probably try to fix unloading soon.
>
> I did some work on this a few months ago but never got around to
> cleaning up the patches. Let me see if I can resurrect that work.

I think there may be merit in these drivers using subsys_init. I've
not had time to investigate, but as far as I can remember this causes
issues with piceport.

For ARM32 host drivers, pci_fixup_irqs (arch/arm/kernel/bios32.c) must
be called before init_service_irqs (portdrv_core.c) otherwise pcieport
acts on invalid information in dev->irq and breaks. It seems that its
possible for the portbus driver to pick up new devices before bios32
has been able to fixup the irqs. Making the host bridge drivers subsys
will overcome this. I guess this hasn't been an issue in the past as
host bridge drivers were always in the arch/ directories.

In any case it may be worth testing this driver with PCIEPORTBUS enabled.

Andrew Murray
