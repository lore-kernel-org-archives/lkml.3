Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaKYXL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:11:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:46301 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbaKYXLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:11:55 -0500
Message-ID: <1416957018.5089.16.camel@kernel.crashing.org>
Subject: Re: [RFC PATCH v3 1/2] drivers: pci: fix pci_mmap_fits()
 implementation for procfs mmap
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Date: Wed, 26 Nov 2014 10:10:18 +1100
In-Reply-To: <20141121175114.GC6578@google.com>
References: <1415877558-8906-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <1415877558-8906-2-git-send-email-lorenzo.pieralisi@arm.com>
	 <20141121175114.GC6578@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 10:51 -0700, Bjorn Helgaas wrote:
> I think this patch is the right thing to do.  I'm going to try to write
> patches for microblaze, mips, powerpc, and sparc that implement their
> pci_resource_to_user() in terms of pcibios_resource_to_bus() (the patches
> are easy; it's the arguments for correctness that take time).  Then I'll
> try to convince myself that those arches are currently broken and will be
> fixed by your patch below.
> 
> But I'll be on vacation all next week, so this will take me some time and
> it may not make the next merge window.

I do remember all sort of funky breakage in that area a long time ago
but I can't quite remember the details and how I ended up with the
current code :-(

The one thing to keep in mind is that there was always confusion in
the userspace users of the /proc interface as to what offset they
had to use... the BAR value or something translated via /proc/.../resources

(Normally the latter but a lot of stuff got it wrong ...)

Cheers,
Ben.


