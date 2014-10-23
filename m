Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaJWQwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:52:18 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48415 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaJWQwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:52:16 -0400
Date: Thu, 23 Oct 2014 10:52:06 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Message-ID: <20141023165206.GB13465@obsidianresearch.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <3256560.C0cZnIlnAv@wuerfel>
 <20141022155914.GB25939@e102568-lin.cambridge.arm.com>
 <2148776.X8NPqiYA6S@wuerfel>
 <20141023091309.GF25302@e106497-lin.cambridge.arm.com>
 <20141023112731.GA5823@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023112731.GA5823@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 12:27:31PM +0100, Lorenzo Pieralisi wrote:

> I think that by removing that, we could switch to CONFIG_PCI_DOMAINS_GENERIC
> on ARM32. I will remove the dependency in drivers/pci/host/pci-mvebu.c
> introduced by commit 2613ba48. pci_sys_data.domain is always 0 in that
> driver so its usefulness is doubtful, comments welcome, copied Jason in
> if he has comments.

pcie-mvebu is like all the other new drivers, each top level DT node
that introduces the interface should have a unique domain number. It
would be very strange (and currently unsupported by the driver) to
ever have more than 1 mvebu top level node in any DT.

Jason
