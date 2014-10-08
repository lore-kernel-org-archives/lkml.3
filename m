Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaJHItu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:49:50 -0400
Received: from mail-bl2on0100.outbound.protection.outlook.com ([65.55.169.100]:22800
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753915AbaJHItq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:49:46 -0400
Date: Wed, 8 Oct 2014 10:49:27 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>, "Rob Herring" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Will Deacon" <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Goutham <sgoutham@cavium.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree
 bindings
Message-ID: <20141008084927.GH31556@rric.localhost>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <1411573068-12952-4-git-send-email-rric@kernel.org>
 <3082935.e3X4GsVUDn@wuerfel>
 <20141007142744.GE31556@rric.localhost>
 <20141007150149.GW4652@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141007150149.GW4652@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.198.111]
X-ClientProxiedBy: AM2PR02CA0039.eurprd02.prod.outlook.com (25.160.28.177) To
 SN2PR0701MB814.namprd07.prod.outlook.com (25.160.16.148)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:SN2PR0701MB814;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6069001)(189002)(199003)(24454002)(164054003)(51704005)(122386002)(106356001)(99396003)(85852003)(120916001)(50466002)(105586002)(97756001)(102836001)(87976001)(33656002)(77096002)(76482002)(76176999)(95666004)(92726001)(92566001)(83506001)(54356999)(31966008)(50986999)(86362001)(93886004)(85306004)(66066001)(23726002)(20776003)(80022003)(46102003)(97736003)(4396001)(64706001)(42186005)(47776003)(101416001)(46406003)(107046002)(21056001)(40100002)(76506005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR0701MB814;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:SN2PR0701MB784;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.10.14 16:01:49, Liviu Dudau wrote:
> On Tue, Oct 07, 2014 at 03:27:44PM +0100, Robert Richter wrote:
> > On 24.09.14 18:06:04, Arnd Bergmann wrote:
> > > > +               compatible = "cavium,thunder-pcie";
> > > > +               device_type = "pci";
> > > > +               msi-parent = <&its>;
> > > > +               bus-range = <0 255>;
> > > > +               #size-cells = <2>;
> > > > +               #address-cells = <3>;
> > > > +               reg = <0x8480 0x00000000 0 0x10000000>;  /* Configuration space */
> > > > +               ranges = <0x03000000 0x8010 0x00000000 0x8010 0x00000000 0x70 0x00000000>, /* mem ranges */
> > > > +                       <0x03000000 0x8300 0x00000000 0x8300 0x00000000 0x80 0x00000000>,
> > > > +                       <0x03000000 0x87e0 0x00000000 0x87e0 0x00000000 0x01 0x00000000>;
> > > > +        };
> > > 
> > > If you claim the entire 0-255 bus range, I think you should also
> > > specify a domain, otherwise it's not predictable which domain you
> > > get.
> > 
> > Liviu's code assigns a unique id to the domain if missing, see
> > of_pci_get_domain_nr(). So I don't think we need to add a "pci-domain"
> > property here.
> 
> Not anymore! That function is gone in v12 onwards. What is in -next has
> a new function called of_get_pci_domain_nr() (slight name change) but
> that only gets the value set in the "linux,pci-domain" property of the
> device node. It is the choice of the host bridge driver to use that
> function or to use pci_get_new_domain_nr() which *does* generate an
> unique id every time it gets called.

I am quite confused a bit on which is the latest code base now. I was
looking into Bjorn's pci/host-generic and there is a different
implemetation:

----
/**
 * This function will try to obtain the host bridge domain number by
 * using of_alias_get_id() call with "pci-domain" as a stem.  If that
 * fails, a local allocator will be used.  The local allocator can
 * be requested to return a new domain_nr if the information is missing
 * from the device tree.
 *
 * @node: device tree node with the domain information
 * @allocate_if_missing: if DT lacks information about the domain nr,
 * allocate a new number.
 *
 * Returns the associated domain number from DT, or a new domain number
 * if DT information is missing and @allocate_if_missing is true.  If
 * @allocate_if_missing is false then the last allocated domain number
 * will be returned.
 */
int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
{
        int domain;

        domain = atomic_read(&of_domain_nr);
        if (domain == -1) {
                /* first run, get max defined domain nr in device tree */
                domain = of_get_max_pci_domain_nr();
                /* then set the start value for allocator to be max + 1 */
                atomic_set(&of_domain_nr, domain + 1);
        }
        domain = of_alias_get_id(node, "pci-domain");
        if (domain == -ENODEV) {
                domain = atomic_read(&of_domain_nr);
                if (allocate_if_missing)
                        atomic_inc(&of_domain_nr);
        }

        return domain;
}
EXPORT_SYMBOL_GPL(of_pci_get_domain_nr);
----

This differs also from v13. Please check.

It would be good to have a stable code base to work with, so I would
prefer incremental patches on top of Bjorn's pci/host-generic.

> > Liviu's DT implementation that assigns a unique number differs a bit
> > from ACPI which states: "If _SEG [aka domain number] does not exist,
> > OSPM assumes that all PCI bus segments are in PCI Segment Group 0."
> > 
> > Maybe of_pci_get_domain_nr() should be similar to ACPI. If there are
> > multiple root bridges, the "pci-domain" property could be forced
> > instead.
> 
> Indeed. But the enforcing is left as an exercise to the host bridge
> implementor for the moment.

Right, can be added later.

Thanks,

-Robert
