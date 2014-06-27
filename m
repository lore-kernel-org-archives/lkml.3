Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaF0LE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:04:26 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56502 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaF0LEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:04:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jon Masters <jonathan@jonmasters.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
Date: Fri, 27 Jun 2014 13:03:34 +0200
Message-ID: <6381366.2IfqZj1r0B@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqKCHf6VXR3FFcBSu1xuhP54dYsAJCZwT-X9p5iTZAOJfQ@mail.gmail.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <20140626085926.GB11244@arm.com> <CAL_JsqKCHf6VXR3FFcBSu1xuhP54dYsAJCZwT-X9p5iTZAOJfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7hPy9bu5hKXINwJaDeajky9XtFGz0M+MmJTLtV/DP7M
 Xn+Ev+2FrtFp+5K+0+O7g5ZaHkPNoi4WojYJGaA3AsnXrSYYfl
 ELLiLoxX5xTA/Z3gEm+KiRa6bJ6GgyFnoyYjGwdnarTvN6c3+z
 fUC4H05x8aWlpqNb4P86bulJIEkT1u44pGbRy4Dgs8SGBufN+S
 mW6YTq7e/EAZgTjhYPE55pch5xPKOezGNpXmYjyaaa/bajXru1
 EWyXQwpdBsKudBqPdNTi2Zs7cSZBB/MM0d1YW/u1C/jZLgZTDR
 cFO1igS+bFBX9UoS/iPdqZFe0dtWjlDuabpmR8fUaRCe9a0U3h
 pY91KVs9qMpqJcfL2Kiw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2014 19:44:21 Rob Herring wrote:
> > Although a bit late, I'm raising this now and hopefully we'll come to a
> > conclusion soon. Delaying arm64 PCIe support even further is not a real
> > option, which leaves us with:
> >
> > 1. Someone else (with enough PCIe knowledge) volunteering to take over
> >    soon or
> 
> Well, I might have 2 months ago, but now I'm pretty booked up.
> 
> > 2. Dropping Liviu's work and going for an arm64-specific implementation
> >    (most likely based on the arm32 implementation, see below)
> 
> 3. Keeping Liviu's patches leaving some of the architecture specific
> bits. I know Arnd and I both commented on it still needing more common
> pieces, but compared to option 2 that would be way better.

Agreed.
 
> 920a685 pci: Add support for creating a generic host_bridge from device tree
> 
> This function could be moved to drivers/of/of_pci.c if having it in
> drivers/pci is too much maintenance burden. However, nearly the same
> code is already being duplicated in every DT enabled ARM PCI host
> driver and will continue as more PCI hosts are added. So this isn't
> really a question of converting other architectures to common PCI host
> infrastructure, but converting DT based PCI hosts to common
> infrastructure. ARM is the only arch moving host drivers to
> drivers/pci ATM. Until other architectures start doing that,
> converting them is pointless.

This is the most important part in my mind. Every implementation gets
this code wrong at least initially, and we have to provide some generic
helper to get the broken code out of host drivers. I don't care whether
that helper is part of the PCI core or part of the OF core.

> 7cfde80 arm64: Add architecture support for PCI
> 
> What is here is really just a function of which option we pick.
> 
> 
> > First option is ideal but there is work to do as laid out by Arnd here:
> >
> > http://article.gmane.org/gmane.linux.kernel/1679304
> 
> I don't agree arm32 is harder than microblaze. Yes, converting ALL of
> arm would be, but that is not necessary. With Liviu's latest branch
> the hacks I previously needed are gone (thanks!), and this is all I
> need to get Versatile PCI working (under QEMU):

I meant converting all of arm32 would be harder, but I agree we don't
have to do it. It would be nice to convert all of the drivers/pci/host
drivers though, iow all multiplatform-enabled ones, and leaving the
current arm32 pci implementation for the platforms we don't want to
convert to multiplatform anyway (footbridge, iop, ixp4xx, ks8695 (?),
pxa, sa1100).

	Arnd
