Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbaGBTKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:10:00 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63936 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaGBTJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:09:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 8/9] pci: Add support for creating a generic host_bridge from device tree
Date: Wed, 02 Jul 2014 21:09:06 +0200
Message-ID: <4233600.RyK6LJF6ZK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140702173113.GJ24879@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <20140702172355.GQ2173@e106497-lin.cambridge.arm.com> <20140702173113.GJ24879@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uZQVUm3SBmKJe8APhEabIqiy1qd9xEm1RXXS3WBlQF8
 HyPcAcjYIgbbRPwQx5oL+zzM9+xgd+uYQus15fmIl8ziWJyDKc
 X7vXqe/P7KnyU+I4H2CFfzgiWLErFl3QqhLzq2lJ1cHQla7ifu
 +zsjVzR6UfV2CBErd3WV6s1iWXJRqwuNHfWBTKWEIrX3hDs1a3
 Ih7pWid2uHy5zlxLzuK53Ej2OjG5UhSeysZqqz0dwiiPJIwnwq
 jFP3RLrXQrjSkDtW9pRqfMpuVi0HDSDta6d4jmvp981WV+qkPa
 +Xs2v97tksyEIOPJAj8Y8OR/yUU2t84gw3ad7klwuCKHNMxPSQ
 NHZFL9L6OW6IoYxXEplE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2014 18:31:13 Will Deacon wrote:
> > > > + err = of_pci_parse_bus_range(parent->of_node, bus_range);
> > > > + if (err) {
> > > > +         dev_info(parent, "No bus range for %s, using default [0-255]\n",
> > > > +                 parent->of_node->full_name);
> > > > +         bus_range->start = 0;
> > > > +         bus_range->end = 255;
> > > > +         bus_range->flags = IORESOURCE_BUS;
> > > 
> > > What about bus_range->name?
> > 
> > Don't know! Is anyone using it?
> 
> I guess /proc/iomem prints it out? I set it in my current driver, if you
> want to take a look.

I don't think the bus resources show up anywhere in procfs. Anyway, it's
always a good idea to give resources a name, if only for debugging purposes.

	Arnd
