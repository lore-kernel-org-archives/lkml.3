Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaH2PgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:36:02 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:39769
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753250AbaH2Pf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:35:59 -0400
Date: Fri, 29 Aug 2014 08:35:36 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
 <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
 <53F5D8D9.7040604@suse.de>
 <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
 <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com>
 <20140825174610.GA13737@obsidianresearch.com> <53FB9AC4.8010704@gmail.com>
 <660fe929-1f16-4e22-8bd3-0388cd363978@BY2FFO11FD038.protection.gbl>
 <540099AF.4020005@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <540099AF.4020005@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20902.005
X-TM-AS-Result: No--41.509-5.0-31-1
X-imss-scan-details: No--41.509-5.0-31-1
Message-ID: <e52ebd6c-2f0d-4ea9-a01f-882212956ace@BL2FFO11FD029.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(479174003)(51444003)(377454003)(51704005)(24454002)(189002)(199003)(80022001)(90102001)(85182001)(87936001)(83072002)(85852003)(99396002)(74662001)(74502001)(31966008)(85202003)(1496007)(83506001)(106466001)(21056001)(76482001)(81342001)(20776003)(47776003)(64706001)(77982001)(79102001)(70736001)(81542001)(93886004)(85306004)(50466002)(92726001)(74316001)(92566001)(86362001)(23676002)(110136001)(53416004)(31696002)(4396001)(44976005)(19580395003)(77096002)(6806004)(83322001)(95666004)(54356999)(76176999)(46102001)(102836001)(104016003)(107046002)(50986999)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB058;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-29 at 05:18PM +0200, Andreas Färber wrote:
> Am 29.08.2014 16:08, schrieb Michal Simek:
> > On 08/25/2014 10:21 PM, Florian Fainelli wrote:
> >> On 08/25/2014 10:46 AM, Jason Gunthorpe wrote:
> >>> On Fri, Aug 22, 2014 at 01:47:09PM -0700, Florian Fainelli wrote:
> >>>
> >>>>>  - the ID based strings seem to be not needed since, IIUC, the core
> >>>>>    reads the ID from the PHY and uses it, so I just left it out not
> >>>>>    trying to figure out how to obtain the correct ID
> >>>>
> >>>> It is not needed, but it is one way to specify a PHY device if you do
> >>>> not know what compatible string to use instead.
> >>>
> >>> No, it is a way to specify a PHY device if the kernel can't auto probe
> >>> the Phy ID.
> >>>
> >>> Last I checked, the kernel doesn't support plain text compatible
> >>> strings for phys - everything is driven on the phy id, either auto
> >>> probed or specified in the DT.
> >>
> >> That's right. Some PHY drivers might be relying on specific compatible
> >> strings though, but not the core PHY library that probes and maps a
> >> driver to a PHY node.
> >>
> >>>
> >>>>>  - the marvell compatible strings are used in our vendor tree. They
> >>>>>    aren't used anywhere but in our vendor tree. I though keeping them is
> >>>>>    nice since it identifies the PHY fully. And in case that level of
> >>>>>    detail is needed at some point it is already there.
> >>>>
> >>>> And this is the recommended way to do it in case we ever need to key a
> >>>> software decision based on the hardware.
> >>>
> >>> All compatible strings need to be documented.
> >>>
> >>> .. and they need to encode more information than you get from the phy
> >>> id - die revsision, package option, functional options, voltage
> >>> codes. Etc.
> >>>
> >>> .. and they actually need to be *right*
> >>
> >> Agreed.
> >>
> >>>
> >>> An example: The kernel reports 88E1318S for all four chips in that
> >>> family, AFAIK you have to read the package marking to figure out which
> >>> you have (it is the same die, with options switched on/off at
> >>> packaging time). People have already posted patches trying to
> >>> helpfully add a 'marvell,88E1318S' compatible string based on kernel
> >>> output. Except it is wrong, it isn't actually the '8S version in the
> >>> HW.
> >>>
> >>> Even worse, Marvell has a whole series of socket compatible phys. Just
> >>> because the board the DT author looked at has a '318, doesn't mean
> >>> that every board ever made will. We've actually already been switching
> >>> between the 318 and 318S for production depending on which has part
> >>> availability.
> >>>
> >>> Basically: don't try to override self-discoverable hardware in DT
> >>> without a really good reason.
> >>
> >> I think that's a very good point, at the very least let's use a
> >> compatible string that contains the full 32-bits PHY OUI.
> > 
> > I think resolution is:
> > 1. Do not use marvell,88e1518 because it is not listed anywhere
> > 2. Do not add ethernet-phy-idAAAA.BBBB because it breaks autodetection
> > if there is different phy on the board and we shouldn't restrict us in this.
> > In spite of autodetection takes some time.
> > 3. "ethernet-phy-ieee802.3-c22" is optional that's why doesn't need to be added
> > 4. Any listed compatible string has to be parsed which takes time
> > 
> > That's why I think make sense not to use any compatible string.
> > This should give us all flexibility which we want to have.
> 
> Sorry, but we do need some node that we can reference via phy-handle
> from the gem node, don't we?
> 
> In that case, is not specifying any compatible string a valid option?
> 
> If you don't want to specify the IDs, then I would've assumed we need to
> specify the -c22 in order to have *some* compatible string in order to
> trigger loading of the appropriate driver module.

The compatible string is listed as optional property for PHYs. So, not
having one is an option, I guess. But, I'd also prefer to at least keep
the -c22 one, since I saw problems when I tried using -c45 (the Zed phy
should support it...).
Also, so far, we haven't had any phy nodes in our Zynq dts files and
Ethernet worked, so the auto-detection there works pretty well
apparently. But it may be problematic if more than a single PHY is on
the MDIO bus, I'd assume.

	Sören
