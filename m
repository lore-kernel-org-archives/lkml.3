Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaE0Na4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:30:56 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57516 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaE0Nax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:30:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
Date: Tue, 27 May 2014 15:30:33 +0200
Message-ID: <5840140.8yGnd4Ycx3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140527125655.63A46C40FCB@trevor.secretlab.ca>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <5279118.J5305KQNjB@wuerfel> <20140527125655.63A46C40FCB@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:d8rkQiftL2bQlmQELpjfIP3veYwWhO6pttIVviA8BrG
 hKwpDK4bcxuaOKXPuOLOcVxDsA7Vo1owN50Y1ls3VOYWljQo+c
 9KXshne8Fd4f0woyx1OQ+MVZoPQSrgrbjpieyzxsLUI3zGNFDS
 9ZeFgyJILLPeby5iW/shyeH/xkLICf2q3HkeVAvLfnJAgRu873
 c85C2JlnyxT08svSzYxq6n0PD21D43LsyQC0XJcghlFPwydAp3
 /nmCZ9kW/7GL2XcvAIuadfkTYkkvDRBSQW7wdm7vVRVqZndhUE
 hDsxDYUwaB9DsUYCNxCIJVGbsBJ5YuNIhGJDWZH6EsBFSfDtMl
 EFmhtiC3MowvVvB8aS6k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 13:56:55 Grant Likely wrote:
> On Fri, 02 May 2014 11:58:30 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 01 May 2014 14:12:10 Grant Likely wrote:
> > > > > I've got two concerns here. of_dma_get_range() retrieves only the first
> > > > > tuple from the dma-ranges property, but it is perfectly valid for
> > > > > dma-ranges to contain multiple tuples. How should we handle it if a
> > > > > device has multiple ranges it can DMA from?
> > > > > 
> > > > 
> > > > We've not found any cases in current Linux where more than one dma-ranges
> > > > would be used. Moreover, The MM (definitely for ARM) isn't supported such
> > > > cases at all (if i understand everything right).
> > > > - there are only one arm_dma_pfn_limit
> > > > - there is only one MM zone is used for ARM
> > > > - some arches like x86,mips can support 2 zones (per arch - not per device or bus)
> > > >   DMA & DMA32, but they configured once and forever per arch.
> > > 
> > > Okay. If anyone ever does implement multiple ranges then this code will
> > > need to be revisited.
> > 
> > I wonder if it's needed for platforms implementing the standard "ARM memory map" [1].
> > The document only talks about addresses as seen from the CPU, and I can see
> > two logical interpretations how the RAM is supposed to be visible from a device:
> > either all RAM would be visible contiguously at DMA address zero, or everything
> > would be visible at the same physical address as the CPU sees it.
> > 
> > If anyone picks the first interpretation, we will have to implement that
> > in Linux. We can of course hope that all hardware designs follow the second
> > interpretation, which would be more convenient for us here.
> 
> Indeed. Hope though we might, I would not be surprised to see a platform
> that does the first. In that case we could probably handle it with a
> ranges property that is DMA-controller facing instead of device facing.
> That would be able to handle the translation between CPU addressing and
> DMA addressing.
> 
> Come to think of it, doesn't PCI DMA have to deal with that situation if
> the PCI window is not 1:1 mapped into the CPU address space?

I think all PCI buses we support so far only need a single entry in the
dma-ranges property.

	Arnd
