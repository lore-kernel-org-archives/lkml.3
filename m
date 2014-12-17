Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaLQODu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:03:50 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:45758 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaLQODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:03:46 -0500
Date: Wed, 17 Dec 2014 14:01:31 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, linux-pci@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/5] PCI: st: disable IO support
Message-ID: <20141217140131.607a1ac7@lxorguk.ukuu.org.uk>
In-Reply-To: <1418812486-12394-6-git-send-email-gabriel.fernandez@linaro.org>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
	<1418812486-12394-6-git-send-email-gabriel.fernandez@linaro.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014 11:34:46 +0100
Gabriel FERNANDEZ <gabriel.fernandez@st.com> wrote:

> sti SoCs PCIe IPs are built around DesignWare IP Core.
> But in these SoCs, PCIe IP doesn't support IO.
> By default, when no IO space is provided, a default one is assigned.
> 
> Add an empty IO resource to the bus, and disable IO by default.

As a point of PCI pedantry I don't think this is quite sufficient. PCI
has a weird corner case where I/O resources are implied rather than
allocated.

For IDE/SATA you may need to something like

	if (class == PCI_CLASS_STORAGE_IDE) {
		u8 progif;
		pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
		progif |= 5;
		pci_write_config_byte(dev, PCI_CLASS_PROG, &progif);
	}

so that any adapter is kicked out of legacy mode and doesn't get implied
I/O resources and interrupts. I don't know if that case matters for your
usage.


