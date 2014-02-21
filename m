Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaBUQ2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:28:32 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:50618 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286AbaBUQ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:28:30 -0500
Date: Fri, 21 Feb 2014 09:28:24 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pcie: Add Xilinx PCIe Host Bridge IP driver
Message-ID: <20140221162824.GA4706@obsidianresearch.com>
References: <1392564830-5868-1-git-send-email-sthokal@xilinx.com>
 <CAErSpo5FGPhgnp8Gfy-1_Lk7ckCi7U5+z5pLnPU+jScPxD5yUQ@mail.gmail.com>
 <20140219003523.GJ29304@obsidianresearch.com>
 <CA+mB=1KSxkN+mKce5k1n93pmAA_FnWYaqNweWzxd4GD3Mo4PZA@mail.gmail.com>
 <20140220174503.GB19893@obsidianresearch.com>
 <CA+mB=1L+QM2cKq==mwYesp=E7S2N-xTiN7AoBvbzAO2UMn0qVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+mB=1L+QM2cKq==mwYesp=E7S2N-xTiN7AoBvbzAO2UMn0qVQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 08:18:00PM +0530, Srikanth Thokala wrote:

> 00:00.0 Class 0604: Device 10ee:7081

So this is great, a root port bridge is exactly correct - I would
recommend using device 1 for this (device 0 is the host bridge in most
cases), but I don't think that has any functional impact.

>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 00000000-00000fff
>         Memory behind bridge: 00000000-000fffff
>         Prefetchable memory behind bridge: 00000000-000fffff

What is going on here?  These ranges should match the MMIO aperture and
critically must enclose the downstream bars:

> 01:00.0 Class 0200: Device 14e4:1677 (rev 11)
>         Region 0: Memory at 60000000 (64-bit, non-prefetchable) [size=64K]
>         Expansion ROM at 60010000 [disabled] [size=64K]

So one of those two is not right..

Jason
