Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935230AbaH0QY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:24:27 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:11100
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934491AbaH0QYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:24:25 -0400
Date: Wed, 27 Aug 2014 18:24:04 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 00/12] Support for creating generic PCI host bridges
 from DT
Message-ID: <20140827162404.GA4818@rric.localhost>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.199.132]
X-ClientProxiedBy: AM3PR02CA007.eurprd02.prod.outlook.com (10.242.240.27) To
 BLUPR0701MB803.namprd07.prod.outlook.com (10.141.253.24)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6069001)(6009001)(164054003)(199003)(24454002)(189002)(51704005)(76482001)(74502001)(97756001)(46406003)(102836001)(50986999)(101416001)(105586002)(83506001)(95666004)(42186005)(31966008)(561944003)(92566001)(79102001)(50466002)(77096002)(76506005)(90102001)(92726001)(74662001)(54356999)(85306004)(21056001)(83072002)(85852003)(77982001)(106356001)(66066001)(20776003)(23726002)(80022001)(86362001)(81542001)(33656002)(47776003)(46102001)(76176999)(107046002)(87976001)(4396001)(99396002)(83322001)(110136001)(81342001)(64706001)(7059011);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR0701MB803;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liviu,

On 12.08.14 17:25:13, Liviu Dudau wrote:
> This is my updated attempt at adding support for generic PCI host
> bridge controllers that make use of device tree information to
> configure themselves. This version incorporates Catalin's proposal
> for managing domain numbers that got Bjorn's approval. I am now requesting
> ACKs from the relevant maintainers as I would like to get the upstream ball
> rolling.
>
> Of the more important changes vs v8, this version has an altered implementation
> of of_create_pci_host_bridge() that allows for easier conversion of architectures
> that use pci_scan_root_bus() in their code rather than pci_create_root_bus().
> With my v8 version of the patchset it would've meant adding back the code
> from pci_scan_root_bus() into architectural code. v9 fixes that and adds
> a callback parameter to of_create_pci_host_bridge() that permits the host
> controller driver to finish the driver setup before the bus is being scanned.
>
> To repeat for the benefit of people writing host bridge drivers on top of
> my patchset: the API for of_create_pci_host_bridge() has changed and it will now
> do all the child bus and device scanning for you, so you only need to provide a
> setup function that will be called before scanning start. I will post a patch
> that Lorenzo has kindly constructed for converting pci-host-generic.c to my API.

would it be possible to provide a branch with this patch set in your
git repo as for v8?

This would make rebasing and testing of our Cavium Thunder code base
much easier. We could then also refer to a public repo where our
patches base on.

Thanks,

-Robert
