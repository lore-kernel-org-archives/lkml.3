Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaIEJk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:40:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40198 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756192AbaIEJk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:40:26 -0400
Date: Fri, 5 Sep 2014 10:39:33 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Robert Richter <rric@kernel.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] arm64, thunder: Document devicetree bindings for
 Cavium Thunder SoC
Message-ID: <20140905093932.GI2172@leverpostej>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <1409903205-2762-4-git-send-email-rric@kernel.org>
 <20140905084200.GE13515@arm.com>
 <20140905093222.GS4703@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905093222.GS4703@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:32:22AM +0100, Robert Richter wrote:
> On 05.09.14 09:42:00, Will Deacon wrote:
> > On Fri, Sep 05, 2014 at 08:46:44AM +0100, Robert Richter wrote:
> > > From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > > 
> > > This patch adds documentation for the devicetree bindings used by the
> > > DT files of Cavium Thunder SoC platforms.
> > > 
> > > Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > > ---
> > >  Documentation/devicetree/bindings/arm/cavium-thunder.txt | 10 ++++++++++
> > >  Documentation/devicetree/bindings/arm/cpus.txt           |  1 +
> > >  2 files changed, 11 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/arm/cavium-thunder.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/arm/cavium-thunder.txt b/Documentation/devicetree/bindings/arm/cavium-thunder.txt
> > > new file mode 100644
> > > index 000000000000..6f63a5866902
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/arm/cavium-thunder.txt
> > > @@ -0,0 +1,10 @@
> > > +Cavium Thunder platform device tree bindings
> > > +--------------------------------------------
> > > +
> > > +Boards with Cavium's Thunder SoC shall have following properties.
> > > +
> > > +Root Node
> > > +---------
> > > +Required root node properties:
> > > +
> > > +  - compatible = "cavium,thunder-88xx";
> > 
> > Is this file necessary? We don't have one for xgene afaict.
> 
> Hmm, looking at Documentation/devicetree/bindings/arm/calxeda.txt
> there is something similar.
> 
> I am fine with both, keeping or removing it.
> 
> Would leave this to the DT maintainers.

Having a required root node compatible is fine, though I would only
expect it to be necessary for errata workarounds if we have no other way
of detecting things.

That said, compatible strings shouldn't have wildcards, so
"cavium,thunder-88xx" should be replaced with something more specific.
Later boards can claim compatibility with that (but should have their
own strings too).

Mark.
