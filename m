Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaJAAnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 20:43:43 -0400
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:13894
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750996AbaJAAnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 20:43:42 -0400
Message-ID: <1412124210.13320.330.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
From: Scott Wood <scottwood@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Jojy Varghese <jojyv@juniper.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "hongtao.jia@freescale.com" <hongtao.jia@freescale.com>
Date: Tue, 30 Sep 2014 19:43:30 -0500
In-Reply-To: <20140930155029.GA4724@roeck-us.net>
References: <D04F3201.10DEB%jojyv@juniper.net>
	 <1412033466.13320.293.camel@snotra.buserror.net>
	 <20140930155029.GA4724@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:9182:1110:33a1:a006]
X-ClientProxiedBy: BN1PR02CA0030.namprd02.prod.outlook.com (10.141.56.30) To
 CY1PR0301MB0730.namprd03.prod.outlook.com (25.160.159.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0730;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(479174003)(377454003)(199003)(51704005)(189002)(377424004)(110136001)(76482002)(104166001)(89996001)(101416001)(50466002)(4396001)(102836001)(76176999)(77156001)(50226001)(97736003)(85306004)(21056001)(47776003)(103116003)(87976001)(99396003)(64706001)(19580405001)(105586002)(33646002)(88136002)(31966008)(19580395003)(62966002)(77096002)(92726001)(93916002)(46102003)(107046002)(50986999)(95666004)(120916001)(42186005)(85852003)(87286001)(23676002)(106356001)(92566001)(86362001)(80022003)(20776003)(10300001)(7059020)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0730;H:[IPv6:2601:2:5800:3f7:9182:1110:33a1:a006];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 08:50 -0700, Guenter Roeck wrote:
> On Mon, Sep 29, 2014 at 06:31:06PM -0500, Scott Wood wrote:
> > On Mon, 2014-09-29 at 23:03 +0000, Jojy Varghese wrote:
> > > 
> > > On 9/29/14 12:06 PM, "Guenter Roeck" <linux@roeck-us.net> wrote:
> > > 
> > > >Those are errors related to PCIe hotplug, and are seen with unexpected
> > > >PCIe
> > > >device removals (triggered, for example, by removing power from a PCIe
> > > >adapter).
> > > >The behavior we see on E5500 is quite similar to the same behavior on
> > > >E500:
> > > >If unhandled, the CPU keeps executing the same instruction over and over
> > > >again
> > > >if there is an error on a PCIe access and thus stalls. I don't know if
> > > >this
> > > >is considered an erratum or expected behavior, but it is one we have to
> > > >address
> > > >since we have to be able to handle that condition. 
> > 
> > The reason I ask is that the handling for e500 was described as an
> > erratum workaround.  If it is an erratum it would be nice to know the
> > erratum number and the full list of affected chips.
> > 
> My understanding, which may be wrong, was that this is expected behavior,
> at least for E5500. I actually thought I had seen it somewhere in the
> specification (response to PCIe errors), but I don't recall where exactly.
> 
> At least for my part I am not aware of an erratum.

Jia Hongtao, can you comment here?

> > > >Ultimately, we'll want
> > > >to
> > > >implement PCIe error handlers for the affected drivers, but that will be
> > > >a next
> > > >step.
> > 
> > For now can we at least print a ratelimited error message?  I don't like
> > the idea of silently ignoring these errors.  I suppose it's a separate
> > issue from extending the workaround to cover e500mc, though.
> > 
> I don't really like the idea of printing an error message pretty much each time
> when an unexpected hotplug event occurs.

Unexpected events seem like the sort of thing you'd want to log, but my
concern is that this might not be the only cause of PCI errors.

-Scott


