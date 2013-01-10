Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab3AJX6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:58:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48717 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3AJX6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:58:44 -0500
Message-ID: <50EF55B0.7030106@wwwdotorg.org>
Date: Thu, 10 Jan 2013 16:58:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 13/14] ARM: tegra: harmony: Initialize PCIe from DT
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-14-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-14-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:43 PM, Thierry Reding wrote:
> With the device tree support in place, probe the PCIe controller from
> the device tree and remove the corresponding workaround in the board
> file.

For some reason, the ports on Harmony fail to initialize correctly with
this driver, although they do with plain next-20130109:

> [    2.698922] tegra-pcie 80003000.pcie-controller: link 0 down, retrying
> [    2.925722] tegra-pcie 80003000.pcie-controller: link 0 down, retrying
> [    3.155411] tegra-pcie 80003000.pcie-controller: link 0 down, retrying
> [    3.178428] tegra-pcie 80003000.pcie-controller: link 0 down, ignoring
> [    3.199713] tegra-pcie 80003000.pcie-controller: failed to add port pci: -19

^^^ There's definitely something plugged into this port, and it's
enumerated OK with the old driver.

> [    3.433551] tegra-pcie 80003000.pcie-controller: link 1 down, retrying
> [    3.667624] tegra-pcie 80003000.pcie-controller: link 1 down, retrying
...
> [    3.901493] tegra-pcie 80003000.pcie-controller: link 1 down, retrying
> [    3.902589] tegra-pcie 80003000.pcie-controller: link 1 down, ignoring
> [    3.902615] tegra-pcie 80003000.pcie-controller: failed to add port pci: -19
> [    3.903780] tegra-pcie 80003000.pcie-controller: PCI host bridge to bus 0000:00
> [    3.903815] pci_bus 0000:00: root bus resource [io  0x82000000-0x8200ffff]
> [    3.903844] pci_bus 0000:00: root bus resource [mem 0xa0000000-0xafffffff]
> [    3.903871] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xbfffffff pref]
> [    3.903901] pci_bus 0000:00: root bus resource [bus 00-ff]

