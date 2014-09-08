Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaIHQje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:39:34 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50948 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbaIHQjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:39:32 -0400
Date: Mon, 8 Sep 2014 10:39:05 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Rob Herring <robherring2@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
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
Message-ID: <20140908163905.GC29679@obsidianresearch.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com>
 <20140908145459.GO27864@e106497-lin.cambridge.arm.com>
 <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com>
 <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 04:59:31PM +0100, Liviu Dudau wrote:

> > I don't really understand how domains are used so it's hard to provide
> > a recommendation here. Do domains even belong in the DT?
> 
> ACPI calls them segments and the way Bjorn explained it to me at some moment was
> that it was an attempt to split up a bus in different groups (or alternatively,
> merge a few busses together). To be honest I haven't seen systems where the domain
> is anything other than zero, but JasonG (or maybe Benjamin) were floating an
> idea of using the domain number to identify physical slots.

A PCI domain qualifies the bus:device.function addressing so that we
can have duplicate BDFs in the system.

So, yes, they belong in DT - each 'top level' PCI node naturally
represents a unique set of BDF addressing below it, and could alias
other top level nodes. The first step to resolve a BDF to a DT node is
to find the correct 'top level' by mapping the domain number.

In an ideal world no small scale system should ever have domains. They
were primarily introduced for large scale NUMA system that actually
have more than 256 PCI busses.

However, from a DT prespective, we've been saying that if the SOC
presents a PCI-E root port that shares nothing with other root ports
(ie aperture, driver instance, config space) then those ports must be
represented by unique 'top level' DT nodes, and each DT node must be
assigned to a Linux PCI domain.

IMHO, designing such a SOC ignores the API guidelines provides by the
PCI-E spec itself, and I hope such a thing won't be considered SBSA
compatible..

Jason
