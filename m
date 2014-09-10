Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaIJSUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:20:40 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60820 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaIJSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:20:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Yijing Wang <wangyijing@huawei.com>,
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
Date: Wed, 10 Sep 2014 20:19:52 +0200
Message-ID: <2908259.jgJNuDxCCa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140909112054.GD29639@arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com> <3780051.0eHpCN6UC9@wuerfel> <20140909112054.GD29639@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5fygzCF5yGkE2WD4BAxybm6UA3NUMs4m5dxP5oa+saT
 HjWyH9gFkyyhjWlZUf2B7B/FHtkfv8C4BujoW+BToUiwwDuH8/
 9VE5lFCxjaRB/fTWppEjih4T/bAF3pKLgnGuW6Ev5ybb2aSK9/
 h7YUqGbD95EGXBWoYy+LcLItgqyhzSUH8d6YsDAd7a0iA2h08A
 B2IZ29gx/Njpey0UFGgb2S8STIZ55XlukU17zgnpYxVVW6ZZbQ
 8USfdKyoOMNzt3TuIMm5IeMr1tfWQiGwF2N3v0iWGIS8SwE6tV
 rxRCGrg/RxMlO3GaA78oBb88BjhdAF0Fah3QwkSiuqYP5+l/VY
 GtwK3n+xd53ILqpAcPiA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 12:20:54 Catalin Marinas wrote:
> 
> We can assume that if a domain is not specified and there is a single
> top level PCIe node, the domain defaults to 0. Are there any arm32
> platforms that require multiple domains (and do not specify a number in
> the DT)?

In theory, I think all of them could work with a single domain, but then
you need to partition the bus number space between the host controllers,
so you have the exact same situation that you either need to make up
random bus numbers or put them in DT.

Using multiple domains is way cleaner for this, even if we have to
make up the numbers.

	Arnd
