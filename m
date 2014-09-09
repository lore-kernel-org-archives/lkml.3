Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbaIIPly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:41:54 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:54699 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbaIIPlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:41:50 -0400
Date: Tue, 9 Sep 2014 09:41:23 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
Message-ID: <20140909154123.GA12906@obsidianresearch.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com>
 <20140908145459.GO27864@e106497-lin.cambridge.arm.com>
 <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com>
 <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
 <540E960D.7080408@huawei.com>
 <20140909084621.GS27864@e106497-lin.cambridge.arm.com>
 <540EC8CB.7010106@huawei.com>
 <CAErSpo4cAfom2=07NYDRfTCdHO22M0v+ueiaZuG6v2Xd18wEnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4cAfom2=07NYDRfTCdHO22M0v+ueiaZuG6v2Xd18wEnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 08:26:19AM -0600, Bjorn Helgaas wrote:

> So as long as the DT tells you the ECAM information for each host
> bridge, that should be sufficient.  The domain number is then just a
> Linux convenience and is not tied to the platform as it is on ia64.

I think this is right for DT systems - the domain is purely internal
to the kernel and userspace, it is used to locate the proper host
bridge driver instance, which contains the proper config accessor (and
register bases, etc).

AFAIK the main reason to have a DT alias to learn the domain number is
to make it stable so things like udev/etc can reliably match on the
PCI location.

This is similar to i2c, etc that use the alias scheme, so IMHO
whatever they do to assign ID's to drivers should be copied for domain
numbers.

Jason
