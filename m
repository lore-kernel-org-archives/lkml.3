Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaGDKVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:21:09 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50861 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaGDKVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:21:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: PCI(e) arch support
Date: Fri, 04 Jul 2014 12:21 +0200
Message-ID: <4342569.JSAyWBcJn2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140704094440.GC6501@e106497-lin.cambridge.arm.com>
References: <1404422876-1160-1-git-send-email-tinamdar@apm.com> <53B5F81B.8010801@freescale.com> <20140704094440.GC6501@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vIpnJImk0EYbiGUlhaX/2B0KXb/GmNgSYyEIuJJfxWU
 yRyXClPslnHbJSgNwTBO+uIfdhLwYwb/3t0mUBzeI2WSA2x8n1
 v+05E+uXpol1xeM+QeQxh6JdIe//NcL0C/gCMM1cY+vU9ycWED
 7Ov945efvVfQ6B3SV2F3VMse2Of5Ubl5GAZQbxIwv+wxmuRoLE
 ORC+ffu4BCSnhWaelHAFj2rEC1j3IHslRKylIk4Er2bGZtK6YZ
 pu7MFhOvLX2vVP49RYJP8T9RMNtsTZC0Ib2RH0pp2H2MPmq4cH
 0hiKuwRLF7lnIPPFzk7FOOgaC5Gzu0UYrOQ4hVdg3sRdz11MLK
 safkDLF3HnKprQhkhWB8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014 10:44:40 Liviu Dudau wrote:
> On Fri, Jul 04, 2014 at 01:40:59AM +0100, Prabhakar Kushwaha wrote:
> > Hi Tanmay, Liviu,
> > On 7/4/2014 2:57 AM, Tanmay Inamdar wrote:
> > > Reposting on request of several people since previously posted one was
> > > corrupted.
> > >
> > > This patch adds the arch support for PCI(e) for arm64. The files
> > > added or modified in this patch are based on PCI(e) support in
> > > 32bit arm.
> > >
> > > Please note that this patch is just for the reference. Liviu Dudau from ARM
> > > has posted his v8 series of patch to support PCIe in arm64.
> > >
> > > The patch will apply against 3.13 Linux Kernel
> > >
> > > Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> > >
> > 
> > do we foresee similar type of changes in u-boot  to support PCI(e) for 
> > ARM64.
> 
> I'm afraid I'm not familiar with u-boot's support for PCI(e), so I cannot
> answer that. As a general matter, ARM has decided to officially support
> UEFI as a bootloader for ARMv8 and that already has support for PCI(e),
> one only needs a driver for the specific host bridge.

Supporting just one boot loader is of course a bit silly, especially when
you know that people will be using all sorts of boot loaders.

A more interesting aspect of this question is what the kernel can expect
the boot loader to have done with the PCI host bridge when the kernel
is entered.

Traditionally, embedded ARM boot loaders have left the PCI host bridge
alone unless they were booting from it, and Linux did all the setup.
With the SBSA class of ARM servers, this is not really practical, and
whatever runs before Linux (typically UEFI) should already set up the
PCI bus and do resource allocation like every other server architecture
does. I would assume that UEFI does this right, and if not we can consider
that a bug.

However, what do we do about PCI hosts that can be used with different
kinds of systems? Do we assume that they all do PCI resource allocation?
Can we decide this on a per host driver basis, or do we need to introduce
an extension to the PCI DT binding to make that decision?

	Arnd
