Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbaGWRnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:43:08 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48298 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347AbaGWRnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:43:06 -0400
Date: Wed, 23 Jul 2014 11:42:29 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>, Richard Zhu <r65037@freescale.com>,
        Marek Vasut <marex@denx.de>, Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-pci@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 4/5] PCI: add PCI controller for keystone PCIe h/w
Message-ID: <20140723174228.GB11270@obsidianresearch.com>
References: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com>
 <1405961925-27248-5-git-send-email-m-karicheri2@ti.com>
 <20140722223527.GA27965@google.com>
 <53CEEB1C.9020202@ti.com>
 <20140722235200.GC27965@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722235200.GC27965@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 05:52:00PM -0600, Bjorn Helgaas wrote:
> If there is a hardware defect, a PCI quirk is a reasonable way to work
> around it, since that's the main purpose of quirks.  fixup_mpss_256()
> is an example of something that sounds superficially similar.

It was my suggestion to engage the PCI-E tuning code. By my
understanding the HW bug is that read response segmentation at the
host bridge does not work - so all read requests from any downstream
device must have responses that fit within a single packet.

This is completely against how the spec envisions things working,
segmentation is a mandatory function. As you point out there is no
parameter bounding the maximum read request size that a completer will
accept.

So, the only fix is that every downstream device must always have a
MRSS set to less than the MPS of the host bridge.

Which means the tuning code must be involved somehow, as that code
controls the MRSS of unrelated devices...

Regards,
Jason
