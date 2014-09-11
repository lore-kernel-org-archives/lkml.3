Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaIKOLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:11:19 -0400
Received: from relmlor3.renesas.com ([210.160.252.173]:49200 "EHLO
	relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755174AbaIKOLN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:11:13 -0400
X-IronPort-AV: E=Sophos;i="5.04,506,1406559600"; 
   d="scan'208";a="168825983"
From: Phil Edworthy <phil.edworthy@renesas.com>
To: Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
CC: Yijing Wang <wangyijing@huawei.com>, Rob Herring <robherring2@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, "Jingoo Han" <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "Suravee Suthikulanit" <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Device Tree ML" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: RE: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
Thread-Topic: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
Thread-Index: AQHPy24jUjleMWha8U6OxwhPaydPWZv3S00AgAAHj4CAAAkdAIAACOuAgADpQICAADAOgIAACE0AgAAi4QCAAgdkAIABSv8w
Date: Thu, 11 Sep 2014 14:11:05 +0000
Message-ID: <ae98d68652f1495a857f081c3a6aecb2@HKXPR06MB168.apcprd06.prod.outlook.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <3780051.0eHpCN6UC9@wuerfel> <20140909112054.GD29639@arm.com>
 <2908259.jgJNuDxCCa@wuerfel>
In-Reply-To: <2908259.jgJNuDxCCa@wuerfel>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [193.141.220.21]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(24454002)(51704005)(54356999)(87936001)(95666004)(20776003)(83322001)(66066001)(80022001)(99396002)(81542001)(46102001)(76482001)(79102001)(77982001)(50986999)(4396001)(76176999)(106116001)(105586002)(101416001)(108616004)(90102001)(85306004)(93886004)(74662001)(2656002)(107046002)(106356001)(31966008)(74502001)(97736003)(64706001)(86362001)(74316001)(85852003)(92566001)(83072002)(76576001)(21056001)(33646002)(7059017)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:HKXPR06MB165;H:HKXPR06MB168.apcprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10 September 2014 19:20, Arnd wrote:
> On Tuesday 09 September 2014 12:20:54 Catalin Marinas wrote:
> >
> > We can assume that if a domain is not specified and there is a single
> > top level PCIe node, the domain defaults to 0. Are there any arm32
> > platforms that require multiple domains (and do not specify a number in
> > the DT)?
> 
> In theory, I think all of them could work with a single domain, but then
> you need to partition the bus number space between the host controllers,
> so you have the exact same situation that you either need to make up
> random bus numbers or put them in DT.
> 
> Using multiple domains is way cleaner for this, even if we have to
> make up the numbers.

Maybe this is a stupid question, but why would you want to specify the domain
in the DT at all? Doesn't every instance of a driver imply a separate domain?

Thanks
Phil 
