Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3BPKIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 05:08:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3BPKH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 05:07:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/4] dmaengine: dw_dmac: move to generic DMA binding
Date: Sat, 16 Feb 2013 10:07:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de> <1360952512-971558-3-git-send-email-arnd@arndb.de> <CAKohpo=u_b9u1=78+tm-rhVR14P0=2XbLrZEDJrQBY5W8LXiCw@mail.gmail.com>
In-Reply-To: <CAKohpo=u_b9u1=78+tm-rhVR14P0=2XbLrZEDJrQBY5W8LXiCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302161007.39657.arnd@arndb.de>
X-Provags-ID: V02:K0:MxYObTeRuNjM+b7P+iU5f3iq2D6H4ia1G4tneNNPAmO
 ILO6CrPUKYx8NsGGA2wUA4PFyia8VYfpCJCgBj3letC+djUeaM
 78J32g8OLRbZSxKseIFsZjGiKExCMPI8YsnVWyeposcIvz9WSA
 B0KEQEmre1y89eZgJxbl9IXSwP+rtFY0fJFrOxeMg4kNNekW16
 MezLOZMR6AmiD9i1M3AxfZIwuC0hKAEM1id3pC0MpXcP1XBFD2
 Lexeb4SSjREHkZSsg55xVMVX8HEy/IqpnbcF/uuvCLITXgaE/m
 ZatQecw6ufvV1CVzl5JmvkhOBGepYt+PF+G1JM6mmMIE1cdUTa
 F+mIKODNtZK7Vv9/+0+I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2013, Viresh Kumar wrote:
> On 15 February 2013 23:51, Arnd Bergmann <arnd@arndb.de> wrote:
> > diff --git a/Documentation/devicetree/bindings/dma/snps-dma.txt b/Documentation/devicetree/bindings/dma/snps-dma.txt
> > +- #dma-cells: must be <3>
> 
> > +DMA clients connected to the Designware DMA controller must use the format
> > +described in the dma.txt file, using a five-cell specifier for each channel.
> 
> s/five/four ?

Right. I thought I had fixed up all instances.

> > +static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
> >  {
> 
> > +       dws->cfg_hi     = 0xffffffff;
> > +       dws->cfg_lo     = 0xffffffff;
> 
> s/0xffffffff/-1 ?

It's an 'unsigned int'. While -1 would work here, I always find it a little
odd to rely on that feature of the C language.

Thannks for the review.

	Arnd
