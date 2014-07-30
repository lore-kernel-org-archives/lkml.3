Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaG3UF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:05:56 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:33416 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbaG3UFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:05:55 -0400
Date: Wed, 30 Jul 2014 14:05:13 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Richard Zhu <r65037@freescale.com>,
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
Message-ID: <20140730200513.GA11918@obsidianresearch.com>
References: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com>
 <1405961925-27248-5-git-send-email-m-karicheri2@ti.com>
 <20140722223527.GA27965@google.com>
 <53CEEB1C.9020202@ti.com>
 <20140722235200.GC27965@google.com>
 <20140723174228.GB11270@obsidianresearch.com>
 <53D948D4.6080603@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D948D4.6080603@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 03:34:44PM -0400, Murali Karicheri wrote:

> • Maximum remote read request size of 256 bytes

The PCI spec simply does not permit a completer to impose this
limitation.

See spec 2.3.1.1

It is not an option to error a read request because it is too
long. All requests must be completed. All completions must be segmented
according to the RCB and Max_Payload_Size.

> completion packets. So it seems to be able to segment up to maximum
> 256 bytes of read request. Where do I find the requirement in PCI
> spec that "read response segmentation at the host bridge does not
> work" ?

You just said it. Segmenting up to only 256 bytes is not a limitation
the completer can impose. Such a device is non-conformant.

> >So, the only fix is that every downstream device must always have a
> >MRSS set to less than the MPS of the host bridge.
> 
> Why this can't be the default behavior in the PCI core? Any cons?

It increases read request traffic and read response latency on the bus
for large transfers.

The MRSS is intented as a performance tuning knob, it is not something
that ever needs to be set properly for correct bus operation.

Jason
