Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764879Ab3DDVaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:30:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52669 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764789Ab3DDVaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:30:05 -0400
Message-ID: <515DF0D9.40007@wwwdotorg.org>
Date: Thu, 04 Apr 2013 15:30:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 07/12] PCI: tegra: Move PCIe driver to drivers/pci/host
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de> <1365000318-28256-8-git-send-email-thierry.reding@avionic-design.de> <515DF096.2000703@wwwdotorg.org>
In-Reply-To: <515DF096.2000703@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 03:28 PM, Stephen Warren wrote:
> On 04/03/2013 08:45 AM, Thierry Reding wrote:
>> Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
>> directory. The motivation is to collect various host controller drivers
>> in the same location in order to facilitate refactoring.
>>
>> The Tegra PCIe driver has been largely rewritten, both in order to turn
>> it into a proper platform driver and to add MSI (based on code by
>> Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
> 
>>  arch/arm/boot/dts/tegra20.dtsi                     |   53 +
> 
> I guess this has to touch both the driver and the dtsi file so that
> bisectabilty isn't broken? I guess that's OK.

Actually, can't you move all the *.dts/*.dtsi changes to the start of
the series, then put the driver conversion patch last, to avoid any
bisectability issues and still keep code and DT changes separate?
