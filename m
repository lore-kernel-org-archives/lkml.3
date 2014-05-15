Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaEOUwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:52:24 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37485 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaEOUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:52:22 -0400
Date: Thu, 15 May 2014 14:52:10 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on
 designware core driver
Message-ID: <20140515205210.GB14722@obsidianresearch.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <6048322.x3M3sdDEWO@wuerfel>
 <5374FD24.8000806@ti.com>
 <22200719.Jb5jnJylJH@wuerfel>
 <20140515183919.GC11650@obsidianresearch.com>
 <53751DDF.40304@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53751DDF.40304@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 04:04:47PM -0400, Murali Karicheri wrote:

> Jason What you mean by "The PCI core handles setting the maximum
> read request size already" I see there is function pcie_write_mrrs()
> in the drivers/pci/probe.c that reads the mps using pcie_get_mps()
> and then set mrrs to mps. But this function is called only from
> pcie_bus_configure_set() that is called by
> pcie_bus_configure_settings()

Right, that is the common code that correctly sets the MRRS that you
should be using instead of quirks.

> None of them gets called on ARM platform.

Hmm, a cursory glance tells me the same as well.

That seems to be the root problem here, ARM needs to do the PCIE
setup just as much as any other arch.

So, I would prefer to see you fix ARM common code to call
pcie_bus_configure_settings() properly, that seems very simple and is
obviously needed for any PCI-E host driver on ARM.

Thoughts? Arnd? Bjorn?

Jason
