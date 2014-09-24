Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaIXQ0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:26:50 -0400
Received: from mail-bn1on0082.outbound.protection.outlook.com ([157.56.110.82]:57559
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751412AbaIXQ0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:26:49 -0400
Date: Wed, 24 Sep 2014 18:26:31 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Sunil Goutham <sgoutham@cavium.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] arm64, defconfig: Enable PCI
Message-ID: <20140924162631.GI31556@rric.localhost>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <1411573068-12952-6-git-send-email-rric@kernel.org>
 <7901403.qjKNmO519a@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7901403.qjKNmO519a@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [78.53.87.200]
X-ClientProxiedBy: DB4PR07CA001.eurprd07.prod.outlook.com (10.242.229.11) To
 DM2PR0701MB809.namprd07.prod.outlook.com (10.242.127.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0701MB809;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(6069001)(24454002)(199003)(51704005)(189002)(20776003)(54356999)(66066001)(46102003)(76506005)(79102003)(81542003)(101416001)(102836001)(86362001)(92566001)(80022003)(21056001)(50986999)(81342003)(74662003)(77982003)(92726001)(50466002)(77096002)(47776003)(42186005)(64706001)(85852003)(4396001)(83072002)(107046002)(23726002)(74502003)(110136001)(97756001)(106356001)(90102001)(85306004)(120916001)(46406003)(76176999)(87976001)(83322001)(76482002)(83506001)(31966008)(97736003)(33656002)(10300001)(95666004)(105586002)(99396003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0701MB809;H:rric.localhost;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.09.14 18:14:11, Arnd Bergmann wrote:
> On Wednesday 24 September 2014 17:37:47 Robert Richter wrote:
> >  config PCI
> >         bool "PCI support"
> > +       default y
> >         help
> >           This feature enables support for PCIe bus system. If you say Y
> >           here, the kernel will include drivers and infrastructure code
> >           to support PCIe bus devices.
> >  
> > +config PCI_MSI
> > +       def_bool PCI
> > +
> >  config PCI_DOMAINS
> >         def_bool PCI
> 
> There is already a PCI_MSI symbol in drivers/pci/Kconfig. Just select that
> from the PCI symbol above rather than defining a second one.

The intention is not to have a second definition, instead this should
enable the default value just for arm64. Thus I put it to
arch/arm64/Kconfig. Otherwise it would be enabled per default on all
archs.

We could have used select in config ARM64, but I tried to avoid using
select due to the dependency issue and instead implement this with
default-y/depends-on. Doing so it can be manually disabled too.

-Robert
