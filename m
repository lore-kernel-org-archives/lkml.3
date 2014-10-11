Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaJKUh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 16:37:57 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:65327 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJKUh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 16:37:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: keystone: add bus notifier to set dma_pfn_offset for pci devices
Date: Sat, 11 Oct 2014 22:37:04 +0200
Message-ID: <7696162.dApA5zbMp7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54387429.2030605@ti.com>
References: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com> <54385187.6030002@ti.com> <54387429.2030605@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JTsTW/IatLiQu/ToxTFW06vvuPaUMg+pEZON4+hNMCP
 6eG2czg0fDnESf3l0pdKtO7eAFvb0eiHvPl0Ef8TOjmKarzVzw
 jh4CuQFg7X7vzD5Wz1yqwTbOBEw6cdRz27t6qJCC4r7fu+YCv7
 SCSzx3RZTjC6MMfoNNVXjbQdBmbTk07HJStIDz3iisxwQhxKse
 SuLBj18bxVrbl0iwgD6MkBrRyJDj3/sHMA4mcHvwqcNP+EKTdR
 mESV8CygDrzIzJ/OJzwsdFeBnK3Rq9mP/hrwlcoAZ80Iq1G07y
 38vvVtnhJWgsJRE9RztJgL8lzoxb/zx3hZ+moaFLnoL3AjI3dZ
 PMw5veKEweBgoZA7hfag=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2014 20:04:57 Santosh Shilimkar wrote:
> On 10/10/14 5:37 PM, Murali Karicheri wrote:
> > Based on this, dma configuration parameters get set for the device which
> > is probed through DT.
> >
> > As PCI devices are attached to the PCI bus during scan, and we don't
> > have DT nodes, we could use similar mechanism to pass the dma-range info
> > from parent host platform device to the PCI devices by adding an
> > of_pci_dma_configure() API and hook it to the PCI probe path some where?
> > Please comment on this so that I can work on the right solution to
> > address this issue for Keystone.
> >
> Adding the DT node parsing code in PCI bus probe path is the right way
> to go about it. You could re-use some of the helpers from dma parsing
> code.
> 
> I let Arnd comment if he disagrees, otherwise I suggest to create an
> RFC patch and post it on the list. We can take it from there.

Yes, I think that is the correct way forward, we need this anyway to
handle IOMMUs correctly, following the patches that Will Deacon did
for platform device IOMMU configuration.
 
> That also reminded me xhci host code issue with dma-ranges since the
> devices are manually created there. I will review that thread as
> well after this merge window.

Right, manually created devices are always problematic, you should
try to avoid those.

	Arnd
