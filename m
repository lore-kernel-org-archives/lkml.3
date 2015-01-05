Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbbAEW04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:26:56 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:59324 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbbAEW0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:26:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] of/pci: add of_pci_dma_configure() update dma configuration
Date: Mon, 05 Jan 2015 23:26:15 +0100
Message-ID: <1671700.LL29F8Iz6R@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54AAEEE1.7020607@ti.com>
References: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com> <2019516.ehiuEv0rdL@wuerfel> <54AAEEE1.7020607@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:7KbApzqx9bXFMs+q0KsUeK9E6qwx5nUGPTmWzTzSFTK9OUTCZV6
 aRdZMR0BZtVUt0yXbf3yci+yTZeidZJOCnd6cuijanh13uC4jAGb5jQSFaAwSt2MLXoEF4T
 titOrnxcF9owihHe3XR18uxQqKAMHJBo+ZlgXN9Gzc3LqyG1KBg2x8FRtk/NpEeyTc7DaTg
 YjuXhv5aOhnsHdlJA7GaA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 15:06:57 Murali Karicheri wrote:
> On 01/03/2015 04:37 PM, Arnd Bergmann wrote:
> > Yes, but we also need to pass a PCI device specific identifier along
> > with the root bus node, because some iommu drivers take the PCI
> > bus/device/function number into account for creating per-function
> > i/o page tables.

> ...

> I will post v3 of the patch with what is agreed before in my response 
> and I understand there is no additional change required based on this 
> particular discussion about iommu. Right?

Actually regarding the bit I wrote above, it might be helpful to pass
the PCI_DEVID() into both of_iommu_configure and of_dma_configure.

While this may or may not be sufficient, I think there is no question
about it being needed for the ARM SMMU with PCI, so we may as well add
it at the point when you touch the same lines already. In the platform
bus case, just pass zero here.

	Arnd
