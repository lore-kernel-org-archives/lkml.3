Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423204Ab3FUHrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:47:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53317 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423034Ab3FUHrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:47:31 -0400
Date: Fri, 21 Jun 2013 09:47:23 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH V10 0/4] PCIe support for Samsung Exynos5440 SoC
Message-ID: <20130621094723.312bc331@skate>
In-Reply-To: <201306210931.58428.arnd@arndb.de>
References: <003901ce6e50$03d039a0$0b70ace0$@samsung.com>
	<201306210931.58428.arnd@arndb.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

On Fri, 21 Jun 2013 09:31:58 +0200, Arnd Bergmann wrote:

> Bjorn, are you still considering to merge this for 3.11 or have you
> closed your tree for the merge window? I think it would be good to get
> it in.

Note that the of/pci changes needed for this driver are merged through
the arm-soc tree, with the of maintainers ACKs. They are already in
arm-soc for-next, through Jason Cooper's tree.

4e23d3f505e8acfeac7cc33d4113fbb5a25c3090 of/pci: Add of_pci_parse_bus_range() function
45ab9702fb47d18dca116b3a0509efa19fbcb27a of/pci: Add of_pci_get_devfn() function
29b635c00f3ebcdaf7a52c4948f6d948ad3757d3 of/pci: Provide support for parsing PCI DT ranges property

Also, it depends on the Marvell PCIe driver (but to a lesser extent),
which is the one that creates the drivers/pci/host/Kconfig and
drivers/pci/host/Makefile.

45361a4fe4464180815157654aabbd2afb4848ad pci: PCIe driver for Marvell Armada 370/XP systems

I am by far not an expert on how to solve merge strategies and so on,
but to avoid conflicts at Linus's level while merging the arm-soc and
pci trees, it would be better if this Samsung PCIe driver could go
through arm-soc (with Bjorn ACK, of course), so that Arnd/Olof can
make sure the ordering is correct with regard to the of/pci changes and
the mvebu/pci driver.

I'll let you discuss that with Jason Cooper.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
