Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaB0Qyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:54:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52309 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaB0Qyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:54:52 -0500
Date: Thu, 27 Feb 2014 16:54:49 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140227165449.GR1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	"linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
 <5722634.VerP6OyMlP@wuerfel>
 <20140227162003.GP1692@e106497-lin.cambridge.arm.com>
 <5679503.gWR3MVnuZs@wuerfel>
MIME-Version: 1.0
In-Reply-To: <5679503.gWR3MVnuZs@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 27 Feb 2014 16:54:50.0548 (UTC) FILETIME=[A116C740:01CF33DC]
X-MC-Unique: 114022716545003001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 04:45:24PM +0000, Arnd Bergmann wrote:
> On Thursday 27 February 2014 16:20:03 Liviu Dudau wrote:
> > On Thu, Feb 27, 2014 at 03:58:41PM +0000, Arnd Bergmann wrote:
> > > On Thursday 27 February 2014 14:13:22 Liviu Dudau wrote:
> > > > 
> > > > It is useful for host bridge drivers as this is the only place where we store
> > > > the physical CPU address for the IO range. This is then needed when setting up the
> > > > translation registers. Also used when calling the pci_ioremap_io function that I'm
> > > > introducing in the AArch64 patches.
> > > 
> > > I don't understand what translation windows you are talking about. Is this
> > > about how the PCI spaces are mapped into the CPU address space? If so, I
> > > would strongly recommend to have this handled by the boot loader before
> > > calling into the kernel. For ARM32, we have a lot of embedded systems
> > > that require the PCI host driver to set up those windows, but actually
> > > it would be much better to just have the firmware tell us what the setup
> > > is and that use that.
> > 
> > The AXI to PCI bridge that I'm using has a set of registers for doing address translation.
> > When it sees an AXI translation that matches the programmed translation window will
> > convert it into a PCI write using the PCI address base written in that translation window.
> > In other words you basically program the DT range into those address translation registers
> > and the bridge does the AXI to PCI conversion for you.
> 
> Right. That should definitely be done in the boot loader
> before Linux is started.

There are examples of other host controllers doing similar things. pci-tegra.c does it in
tegra_pcie_setup_translations(), pcie-designware.c has dw_pcie_prog_viewport_*() functions.

I'm afraid for the moment the bootloader on my platform is not going to be of too much use on
this, so it will have to be initially in Linux.

Best regards,
Liviu

> 
> 
> 	Arnd
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

