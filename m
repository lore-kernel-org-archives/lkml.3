Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbaDKOPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:15:43 -0400
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:18260
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756691AbaDKOPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:15:40 -0400
Message-ID: <1397226091.8304.5.camel@dinh-ubuntu>
Subject: Re: [PATCH 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
From: Thor Thayer <tthayer@altera.com>
To: Rob Herring <robherring2@gmail.com>
CC: delicious quinoa <delicious.quinoa@gmail.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Doug Thompson <dougthompson@xmission.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Dinh Nguyen <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Fri, 11 Apr 2014 09:21:31 -0500
In-Reply-To: <CAL_JsqJRweynpCA7LMFU4wfa71XzjGC3b8H9XKJpogf5H93h_A@mail.gmail.com>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
	 <1396907649-20212-2-git-send-email-tthayer@altera.com>
	 <20140408133818.GB16054@pengutronix.de>
	 <1396967390.23349.15.camel@dinh-ubuntu>
	 <20140408143327.GC16054@pengutronix.de>
	 <CANk1AXR0bDENDV673M-AVXNWHmGuee5SGc+ZnPqdBdEBwJXQXQ@mail.gmail.com>
	 <CAL_JsqJRweynpCA7LMFU4wfa71XzjGC3b8H9XKJpogf5H93h_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(979002)(6009001)(458001)(51704005)(377424004)(377454003)(199002)(189002)(24454002)(62966002)(33646001)(93916002)(86362001)(44976005)(47776003)(87936001)(20776003)(83322001)(42186004)(19580395003)(33716001)(50986999)(76176999)(23676002)(87286001)(80022001)(99396002)(89996001)(16796002)(84676001)(79102001)(19580405001)(2009001)(92726001)(74502001)(77156001)(97736001)(31966008)(81542001)(92566001)(77982001)(81342001)(88136002)(50226001)(6806004)(74662001)(85852003)(46102001)(80976001)(83072002)(50466002)(76482001)(4396001)(1411001)(99106001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB042;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:EE84F462.A7E25719.BDD77F33.48CAF0F1.2030C;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0178184651
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 13:52 -0500, Rob Herring wrote:
> On Tue, Apr 8, 2014 at 11:02 AM, delicious quinoa
> <delicious.quinoa@gmail.com> wrote:
> > On Tue, Apr 8, 2014 at 9:33 AM, Steffen Trumtrar
> > <s.trumtrar@pengutronix.de> wrote:
> >> On Tue, Apr 08, 2014 at 09:29:50AM -0500, Thor Thayer wrote:
> >>> On Tue, 2014-04-08 at 15:38 +0200, Steffen Trumtrar wrote:
> >>> > Hi!
> >>> >
> >>> > On Mon, Apr 07, 2014 at 04:54:07PM -0500, tthayer@altera.com wrote:
> >>> > > From: Thor Thayer <tthayer@altera.com>
> >>> > >
> >>> > > Addition of the Altera SDRAM controller bindings and device
> >>> > > tree changes to the Altera SoC project.
> >>> > >
> >>> [snip]
> >>> > > +
> >>> > > +Required properties:
> >>> > > +- compatible : "altr,sdr-ctl", "syscon";
> >>> > > +                Note that syscon is invoked for this device to support the FPGA
> >>> > > +         bridge driver, EDAC driver and other devices that share the
> >>> > > +         registers.
> >>> > > +- reg : Should contain 1 register ranges(address and length)
> >>> >
> >>> > I haven't really thought this through, but why would the FPGA bridge driver
> >>> > access the sdram controller? For releasing the resets in fpgaportrst ? Or is
> >>> > there more?
> >>>
> >>> Hi Steffan. No, not for resets. We need to enable the FPGA to SDRAM
> >>> path. Our SDRAM controller allows FPGA master access to the SDRAM.
> >>>
> >>
> >> Yes. But what you have to do to enable the path is let the FPGA port you use
> >> out of reset. And that is it as far as I can see. The rest happens in the
> >> bitstream. Or is there more to enable the path?
> >> The FPGA2SDRAM bridge is the one I didn't use as of yet, so if I miss something
> >> please elaborate.
> >
> > Hi Steffen,
> >
> > The sdram controller is used by two drivers.  That's why we want to
> > specify "syscon" here.  The other driver is the FPGA bridge driver.
> > Its functionality is very separate from what this driver is doing (we
> > are not enabling the bridge in this driver; we are enabling the
> > monitoring and resetting the interrupt bit of the EDAC).  We wanted to
> > specify "syscon" her so that we don't have to have to change it for
> > the other driver.
> 
> But are there actually overlapping registers which are accessed by
> both drivers and need the protection of regmap?
> 
> Perhaps MFD is more appropriate than syscon?

Hi Rob,

We are accessing bits in the SDRAM Controller's Control register which
has other bits that configure the SDRAM controller. Since this main
control register may be accessed by other drivers (more likely for
reading the current SDRAM configuration setup than for writing), the
syscon still seems like an appropriate use.

Thor


> 
> Rob


