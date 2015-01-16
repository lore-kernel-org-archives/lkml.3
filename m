Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbbAPPO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:14:58 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:58015 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbbAPPOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:14:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, Tom Lendacky <thomas.lendacky@amd.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Date: Fri, 16 Jan 2015 16:14:13 +0100
Message-ID: <2198633.UpIyI82Yon@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150116145545.GR7091@arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <54B9240A.7060003@amd.com> <20150116145545.GR7091@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Wy8jiL7VlY9Yo1Q4ynUEnK0UOtqnmwQaC+4NRgbaONiTWy+Q0Kh
 J/FuyOPlWQ1G9SLYMqp4h/XNYDHfHLIEaVPBIo9ICfARMKLN1c48v3tyCA+zu5aKDaIUYIW
 a+JK1Q3dFS9jY7/Uyg6JVAH4NodcTUC3gexyEBnLDE1XVwAvDWC8GRs20AT+L/AQkhE9HK6
 AyFTQ7OpIedYH0hvitz9w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 14:55:45 Will Deacon wrote:
> Hi Tom,
> 
> On Fri, Jan 16, 2015 at 02:45:30PM +0000, Tom Lendacky wrote:
> > I have tested ACPI-enablement patches for the amd-xgbe/amd-xgbe-phy
> > drivers that I'm about to submit upstream with the V7 patch series
> > on the AMD Seattle server platform. There does not appear to be support
> > for the _CCA attribute in this patch series. The amd-xgbe driver will
> > setup the device domain and cache attributes based on the presence of
> > this attribute, but it requires the arch support to assign the proper
> > DMA operations in order for it to all work correctly.
> > 
> > Overriding the _CCA attribute in the driver, I was able to successfully
> > test the driver and this patch series.
> 
> Hopefully this will all be addressed when the IORT parts of ACPI have
> settled down (the current proposal allows for these attributes to be
> described as well as their interaction with things like IOMMUs).
> 
> In the meantime, are you falling back to non-coherent DMA? If so, what
> attributes have you settled on? We need to be really careful not to
> corrupt data during cache invalidatation when mapping a non-coherent
> buffer for the CPU.

I think in case of ACPI we should use cache-coherent as the default,
as this is what all servers will use for DMA masters.

	Arnd
