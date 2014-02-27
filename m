Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaB0Qp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:45:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaB0Qp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:45:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] pci: Add support for creating a generic host_bridge from device tree
Date: Thu, 27 Feb 2014 17:45:24 +0100
Message-ID: <5679503.gWR3MVnuZs@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140227162003.GP1692@e106497-lin.cambridge.arm.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <5722634.VerP6OyMlP@wuerfel> <20140227162003.GP1692@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:23QYYg3CWOqzz0+mIWexpR6CsKezEh5HJLkTfyrZ/Ou
 /KgPC118pSTbsUsFchF5c4E+nGxXzsR27OIfCNoUCuzNSU3a3C
 uOiqo0mGBH05rmY7hP0uk+tQEyFSQcCe4LBwf5iJ9L3WUXEEX1
 QsKzLZrcu9Bf+leG/2w1U8yMaudlC1JLNHlgDjXex432+lqjTl
 5/Z4DwCnS/YaHJL9JDeS1etgB5wsiAkHxclSKDCfNYfc8UFpV0
 6UKmcG/tZ9TGj6Dr0MFMnW3lqhlGmiTar29//OEPup8wx6S1bs
 UkCWuqE0NWmHVk/8rF092T3H+s+8J5k6q28GUcBeP2CqHGQd7q
 6Qmk8wPUOADZO6iREhWY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 16:20:03 Liviu Dudau wrote:
> On Thu, Feb 27, 2014 at 03:58:41PM +0000, Arnd Bergmann wrote:
> > On Thursday 27 February 2014 14:13:22 Liviu Dudau wrote:
> > > 
> > > It is useful for host bridge drivers as this is the only place where we store
> > > the physical CPU address for the IO range. This is then needed when setting up the
> > > translation registers. Also used when calling the pci_ioremap_io function that I'm
> > > introducing in the AArch64 patches.
> > 
> > I don't understand what translation windows you are talking about. Is this
> > about how the PCI spaces are mapped into the CPU address space? If so, I
> > would strongly recommend to have this handled by the boot loader before
> > calling into the kernel. For ARM32, we have a lot of embedded systems
> > that require the PCI host driver to set up those windows, but actually
> > it would be much better to just have the firmware tell us what the setup
> > is and that use that.
> 
> The AXI to PCI bridge that I'm using has a set of registers for doing address translation.
> When it sees an AXI translation that matches the programmed translation window will
> convert it into a PCI write using the PCI address base written in that translation window.
> In other words you basically program the DT range into those address translation registers
> and the bridge does the AXI to PCI conversion for you.

Right. That should definitely be done in the boot loader
before Linux is started.


	Arnd
