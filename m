Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3AKAPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:15:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54076 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab3AKAPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:15:12 -0500
Message-ID: <50EF598B.2030307@wwwdotorg.org>
Date: Thu, 10 Jan 2013 17:15:07 -0700
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
Subject: Re: [PATCH 09/14] ARM: tegra: Move pmc.h to include/mach
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-10-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-10-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:43 PM, Thierry Reding wrote:
> In preparation for moving the PCIe driver into the drivers/pci/host
> directory, this header, which contains prototypes that are required by
> the PCIe driver, needs to be moved to a globally visible location.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> Note that eventually the code in pmc.c and powergate.c should probably
> be split out into a separate driver. The PMC registers are also directly
> accessed from tegra20_clocks.c and tegra30_clocks.c, so that it might be
> required to provide that functionality through the new driver as well.
> ---
>  arch/arm/mach-tegra/common.c           |  2 +-
>  arch/arm/mach-tegra/include/mach/pmc.h | 24 ++++++++++++++++++++++++
>  arch/arm/mach-tegra/pmc.h              | 24 ------------------------

On IRC, we'd talked about putting the public functionality in
include/linux/tegra-pmc.h so that we wouldn't add to include/mach, which
would make it harder to make Tegra support ARM multi-platform. Perhaps
that IRC discussion happened after you posted this series?
