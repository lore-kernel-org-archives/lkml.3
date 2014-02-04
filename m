Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaBDTV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:21:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbaBDTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:21:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Tue, 04 Feb 2014 20:21:38 +0100
Message-ID: <4118142.2mQ5BlBdTZ@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140204191055.GC25695@obsidianresearch.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <8676627.b6SYsazoah@wuerfel> <20140204191055.GC25695@obsidianresearch.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Bki1vnegN/BTBJ6i+V5nDqk5Wj+1UpbftvDC/fmooLn
 cu5a4tVMBSNSiPNpQaeIgYfeiT33i6iJlEs/Rw3BWWNypn3osS
 WYK3w8viwPmeNQgsLeHhrh+wceH58DAptA//Ntd30WK6Fzufbx
 ESkn1/9UQ7iKTVZPIx/cHACb4XPTZSckLFw/VKY6W9DJQy5Psz
 sPqFbDXob7OKZn0hBVfFPphMajO4InSjwQ6bL0xXzRbCfS1vRh
 nVJCm3d3tg1xGJ3FITgEPDmbzydpZRL9EvKGxIGzw1KPZSJtwm
 y88wwPoisdpz/k58OxHx2OKZGatdBFSGTGKFJ5uavIDINkAwJc
 f2BQ4xYrLEIc/BGsQrMs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 February 2014 12:10:55 Jason Gunthorpe wrote:
> 
> For instance to support peer-to-peer IO you need to have a consisent,
> non-overlapping set of bus/device/function/tag to uniquely route TLPs
> within the chip. Cross domain TLP routing in HW is non-trivial.

Yes, that is a good reason.

> IOMMUs (and SR-IOv) rely on the BDF to identify the originating device
> for each TLP. Multiple domains means a much more complex IOMMU
> environment.

I fear we already have to support complex IOMMU setups on ARM,
whether there are multiple PCI domains or not. But it would be
nice in theory not to require it.

> Failure to integrate on-chip devices into the PCI world also means
> thing like SR-IOv won't work sanely with on-chip devices.

I'd consider this a feature ;)

But you are probably right: people will do SR-IOV whether we like
it or not, and they will try to do it on non-PCI devices too,
and great suffering will be involved.

	Arnd
