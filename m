Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaEFNc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:32:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54660 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaEFNc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:32:57 -0400
Message-ID: <5368E45A.1000205@ti.com>
Date: Tue, 6 May 2014 09:32:10 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <CAErSpo6gYT34-sOvNgEdV+3wxv=Fdqtx7c1d-4577mFydLtZMg@mail.gmail.com> <1399347878.20388.96.camel@pasglop> <5699845.615YLDid8d@wuerfel>
In-Reply-To: <5699845.615YLDid8d@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 05:54 AM, Arnd Bergmann wrote:
> On Tuesday 06 May 2014 13:44:38 Benjamin Herrenschmidt wrote:
>> On Mon, 2014-05-05 at 16:28 -0600, Bjorn Helgaas wrote:
>>> I still wonder whether arm, powerpc, and tile (and I just noticed
>>> microblaze also has a similar dma_direct_map_page()) could all be
>>> handled by attaching devices to a generic trivial IOMMU driver
>>> parameterized with the appropriate constant offset.
> 

[..]

> It may be easier to replace set_arch_dma_coherent_ops() with
> a generic function that handles all cases:
> 
> int set_arch_dma_ops(struct device *dev, bool coherent,
> 		phys_addr_t offset, struct device_node *iommu);
> 
> and let the architecture handle the cases it needs.
> 
>> On powerpc, the offset is not constant, it can be per-device.
> 
> I think that's the case on all of them. The code under review here
> is what parses the dma-ranges property in order to put the correct
> value into the per-device structure.
> 
Yep. The per-device property need is one of the reason, we added the
information to struct device. The constant need not be same though
on keystone it is same for all devices.

Regards,
Santosh
