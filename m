Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaCGAZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:25:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:57645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaCGAZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:25:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v5 1/7] pci: Introduce pci_register_io_range() helper function.
Date: Fri, 7 Mar 2014 01:24:12 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com> <201403042330.09607.arnd@arndb.de> <20140306160442.GG6457@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140306160442.GG6457@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403070124.13139.arnd@arndb.de>
X-Provags-ID: V02:K0:D8u+F0PiAV23Mz239o5R2E7Qpmp7fcPU01NmKdIOu2D
 s1l5ws8g/IlMvVTSm95/+s87TQyJh3yloen76ngcNFRgEE0sI3
 /1Q+atBePg3JZT32j4wtFiXpp248DS0eueftFoEW0x+3dJdaDB
 k7R3WNW0ixfcN4qSGYr5kGjftyqfd6Pqkc8Nd95TXDAWeFL+Yt
 l6P+evIhU7ly5PeCThast+L8W/wO/7Wmm9hpKSd8XKFE/Hddz2
 rx1iosUvk/0biGvWyPuwvwdqXRv4+knlvRwh5amLWiG6TQUqlT
 73swDUbn4ZvgbiONwiwZfqZU1LCDswplxvCYUo7ucZuZNut6LJ
 3vFqDTunLX87a7kHfkL/5x5sprYWOFSjJDPd+cBpy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2014, Liviu Dudau wrote:
> On Tue, Mar 04, 2014 at 10:30:09PM +0000, Arnd Bergmann wrote:
> > On Tuesday 04 March 2014, Liviu Dudau wrote:
> > > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> > > +{
> > > +       return 0;
> > > +}
> > > +
> > 
> > How about returning an error here? You don't actually register the range.
> 
> That's not the intention here. I basically want a nop, as by default (read x86)
> we do nothing with the IO range.

I think x86 is a bad default though, because that is the exception rather than
the rule. I also think that on x86, you shouldn't have an entry for the I/O
space in the "ranges" property since there is no translation, and then we don't
call this function.

PCI devices described in DT on x86 would still be able to list their I/O BARs
in DT, but you don't ever translate them into MMIO ranges.

	Arnd
