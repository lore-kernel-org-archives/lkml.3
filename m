Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaJGOnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:43:53 -0400
Received: from mail-bn1on0068.outbound.protection.outlook.com ([157.56.110.68]:44672
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752904AbaJGOnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:43:52 -0400
Date: Tue, 7 Oct 2014 16:27:44 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <liviu.dudau@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, Robert Richter <rric@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, <devicetree@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sunil Goutham <sgoutham@cavium.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree
 bindings
Message-ID: <20141007142744.GE31556@rric.localhost>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <1411573068-12952-4-git-send-email-rric@kernel.org>
 <3082935.e3X4GsVUDn@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3082935.e3X4GsVUDn@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.195.77]
X-ClientProxiedBy: AMSPR04CA0049.eurprd04.prod.outlook.com (10.242.87.167) To
 SN2PR0701MB816.namprd07.prod.outlook.com (25.160.16.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:SN2PR0701MB816;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6069001)(6009001)(189002)(199003)(24454002)(42186005)(47776003)(97756001)(85852003)(83506001)(120916001)(4396001)(50986999)(23726002)(40100002)(31966008)(80022003)(76506005)(54356999)(76176999)(87976001)(46102003)(64706001)(20776003)(77096002)(66066001)(101416001)(86362001)(50466002)(46406003)(92566001)(105586002)(102836001)(106356001)(33656002)(95666004)(92726001)(76482002)(99396003)(107046002)(85306004)(97736003)(122386002)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR0701MB816;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.09.14 18:06:04, Arnd Bergmann wrote:
> > +               compatible = "cavium,thunder-pcie";
> > +               device_type = "pci";
> > +               msi-parent = <&its>;
> > +               bus-range = <0 255>;
> > +               #size-cells = <2>;
> > +               #address-cells = <3>;
> > +               reg = <0x8480 0x00000000 0 0x10000000>;  /* Configuration space */
> > +               ranges = <0x03000000 0x8010 0x00000000 0x8010 0x00000000 0x70 0x00000000>, /* mem ranges */
> > +                       <0x03000000 0x8300 0x00000000 0x8300 0x00000000 0x80 0x00000000>,
> > +                       <0x03000000 0x87e0 0x00000000 0x87e0 0x00000000 0x01 0x00000000>;
> > +        };
> 
> If you claim the entire 0-255 bus range, I think you should also
> specify a domain, otherwise it's not predictable which domain you
> get.

Liviu's code assigns a unique id to the domain if missing, see
of_pci_get_domain_nr(). So I don't think we need to add a "pci-domain"
property here.

Liviu's DT implementation that assigns a unique number differs a bit
from ACPI which states: "If _SEG [aka domain number] does not exist,
OSPM assumes that all PCI bus segments are in PCI Segment Group 0."

Maybe of_pci_get_domain_nr() should be similar to ACPI. If there are
multiple root bridges, the "pci-domain" property could be forced
instead.

-Robert
