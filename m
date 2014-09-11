Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaIKOu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:50:29 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59830 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaIKOuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:50:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robherring2@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI domain_nr
Date: Thu, 11 Sep 2014 16:49:56 +0200
Message-ID: <15029597.7ylOekBBOx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <ae98d68652f1495a857f081c3a6aecb2@HKXPR06MB168.apcprd06.prod.outlook.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com> <2908259.jgJNuDxCCa@wuerfel> <ae98d68652f1495a857f081c3a6aecb2@HKXPR06MB168.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oMfjNzqlo+7Fw6vs6oSUYxqlA/JHMnA8jPLq8NO2wnz
 3viS9jv7YZZvzdcgOKc2pWEzXYitudRnt0Bmg8qg/CtpiWCJfn
 hnuUaySNmvj3Pz2mpffaTgXAP3v6U0SehSc9Cnzz/Er+VkbtCt
 GC+riui275dzoNz7+JetP43IvfcLx55ldl4CiSEdEAZxBeO+r0
 ovip8VTs7NXPyXVS058BlfcKBtCP2ZWV9+SClLUlGuO4TuZTNf
 E4h8oA22aESqB9qoIgzp/nopLc5xWXdXIe+M3FQaNQg40pzRaM
 okUlKZVb61WQpzbtRsZQaiACJeuMMOK3kutd0qtdiX7u+FcGeS
 9h7qNJqc59pKcsHUm2mA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2014 14:11:05 Phil Edworthy wrote:
> On 10 September 2014 19:20, Arnd wrote:
> > On Tuesday 09 September 2014 12:20:54 Catalin Marinas wrote:
> > >
> > > We can assume that if a domain is not specified and there is a single
> > > top level PCIe node, the domain defaults to 0. Are there any arm32
> > > platforms that require multiple domains (and do not specify a number in
> > > the DT)?
> > 
> > In theory, I think all of them could work with a single domain, but then
> > you need to partition the bus number space between the host controllers,
> > so you have the exact same situation that you either need to make up
> > random bus numbers or put them in DT.
> > 
> > Using multiple domains is way cleaner for this, even if we have to
> > make up the numbers.
> 
> Maybe this is a stupid question, but why would you want to specify the domain
> in the DT at all? Doesn't every instance of a driver imply a separate domain?

See Jason Gunthorpe's latest reply on the topic. In short, the domain is
visible to user space and we want it to be stable across boots when
user configuration refers to devices by domain:bus:device:function
numbers.

	Arnd
