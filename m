Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbbAPOzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:55:55 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36142 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbbAPOzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:55:52 -0500
Date: Fri, 16 Jan 2015 14:55:45 +0000
From: Will Deacon <will.deacon@arm.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Message-ID: <20150116145545.GR7091@arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <54B8BB24.2020408@linaro.org>
 <54B9240A.7060003@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B9240A.7060003@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Fri, Jan 16, 2015 at 02:45:30PM +0000, Tom Lendacky wrote:
> I have tested ACPI-enablement patches for the amd-xgbe/amd-xgbe-phy
> drivers that I'm about to submit upstream with the V7 patch series
> on the AMD Seattle server platform. There does not appear to be support
> for the _CCA attribute in this patch series. The amd-xgbe driver will
> setup the device domain and cache attributes based on the presence of
> this attribute, but it requires the arch support to assign the proper
> DMA operations in order for it to all work correctly.
> 
> Overriding the _CCA attribute in the driver, I was able to successfully
> test the driver and this patch series.

Hopefully this will all be addressed when the IORT parts of ACPI have
settled down (the current proposal allows for these attributes to be
described as well as their interaction with things like IOMMUs).

In the meantime, are you falling back to non-coherent DMA? If so, what
attributes have you settled on? We need to be really careful not to
corrupt data during cache invalidatation when mapping a non-coherent
buffer for the CPU.

Will
