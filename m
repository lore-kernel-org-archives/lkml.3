Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaKRM3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:29:01 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:54896 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaKRM27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:28:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Suravee.Suthikulpanit@amd.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wuyun <wuyun.wu@huawei.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 00/16] Refine PCI host bridge scan interfaces
Date: Tue, 18 Nov 2014 13:27:45 +0100
Message-ID: <1534030.bkpIToWlHq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546B38F5.6050708@huawei.com>
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <20535707.3sA6NjSINh@wuerfel> <546B38F5.6050708@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DveuiF/FvAC6nICcPiyeKi3cpa6yLBe6cr8688KUSa0
 05BSOEHRfGflVA/njaHSUfyCDL/3ehNKOyUr8NkvkWZCkujn3e
 xkYIA47s3JCoLbNooTofgEvP6sXVAI8WKVJ1XQ/TES3kEy46TZ
 iK1TuwI/2Y4mzHPSfpWdQ32CKQ9rWJdztXGjHYvVMDAr8d5/eN
 Z+4aQX1ZzWsEPXmNabMucCLVeX1UU44KWtcICRdkqkucMQxwYv
 saaTFSSd0qbseLWjffh6OMoy8iHsg+Ec6f/2yfHd0xHHJXRA5Q
 zlLyCtVVIZvptrRiMaJZJuRsMBEPywojE7fkxTxVEIdH0P3all
 AkkaPuL4Z+/nZGTbwYcg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2014 20:17:57 Yijing Wang wrote:
> 
> >>
> >> I hope platforms with ACPI or DT could both use pci_create_host_bridge().
> >> Why we need to use two different ways to process it ?
> > 
> > These are completely different use cases:
> > 
> > a) For DT, we want loadable device drivers that start by probing a host
> >    bridge device which was added through the DT platform code. The
> >    driver is self-contained, and eventually we want to be able to unload
> >    it. We have lots of different per-soc drivers that require different
> >    quirks
> > 
> > b) For ACPI, the interface is defined in the ACPI spec across architectures
> >    and SoCs, we don't have host bridge drivers and the code that initializes
> >    the PCI is required early during boot and called from architecture
> >    code. There is no parent device, as ACPI sees PCI as a fundamental building
> >    block by itself, and there are no drivers because the firmware does
> >    the initial hardware setup, so we only have to access the config space.
> 
> Hmmm, I'm a little confused, so why you think ACPI host driver should not use
> pci_create_host_bridge(), because ACPI PCI driver has no parent device ?

It's one of the difference. Having a parent device can certainly make your
life simpler, since you have devm_kzalloc(), dev_info(), etc. Coming from
the other end, I think ACPI needs PCI to be available during early boot,
at a time where we might not want pci_create_host_bridge() to do the
right thing.

	Arnd
