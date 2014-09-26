Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaIZNj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:39:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46563 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508AbaIZNjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:39:24 -0400
Date: Fri, 26 Sep 2014 14:39:20 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "hns@goldelico.com" <hns@goldelico.com>,
        "sre@debian.org" <sre@debian.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Documentation: DT: Document twl4030-madc-battery
 bindings.
Message-ID: <20140926133920.GG7422@leverpostej>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
 <1394052739-8589-4-git-send-email-marek@goldelico.com>
 <20140922110320.GI3290@leverpostej>
 <CAAfyv352GrgTzKf-XxPNthtoR9rdhssnOSdx1mZ-q=D4okBSAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv352GrgTzKf-XxPNthtoR9rdhssnOSdx1mZ-q=D4okBSAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 09:35:03PM +0100, Belisko Marek wrote:
> Hi Mark,
> 
> On Mon, Sep 22, 2014 at 1:03 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > Hi,
> >
> > On Wed, Mar 05, 2014 at 08:52:19PM +0000, Marek Belisko wrote:
> >> Signed-off-by: Marek Belisko <marek@goldelico.com>
> >> ---
> >>  .../bindings/power_supply/twl4030_madc_battery.txt | 43 ++++++++++++++++++++++
> >>  1 file changed, 43 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> >> new file mode 100644
> >> index 0000000..fd0b6d2
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> >> @@ -0,0 +1,43 @@
> >> +twl4030_madc_battery
> >> +
> >> +Required properties:
> >> + - compatible : "ti,twl4030-madc-battery"
> >
> > I'm rather confused by this; the code seems to have stripped away all
> > the twl4030 dependencies and this now seems to be a generic ADC battery
> > status driver. So why does this need to be specific to twl4030?
> You are right. Also possibly driver name is incorrect :). Better name could be
> ti, madc-battery.

Ok.

> >
> >> + - capacity : battery capacity in uAh
> >
> > I would make the units explicit in the name; "capacity" can be measured
> > in many ways.
> OK capacity_uAh should be fine I believe.

Well, "capacity-uah" to match naming conventions.

> >
> >> + - charging-calibration-data : list of voltage(mV):level(%) values
> >> +     for charging calibration (see example)
> >> + - discharging-calibration-data : list of voltage(mV):level(%) values
> >> +     for discharging calibration (see example)
> >
> > Regardless of the prefixing of these property names, the specifics are
> > unclear to me.
> Do you suggest to rename it completely or is enough to add "ti, " prefix?

I'm not suggesting prefixing. I'm suggesting that "calibration data"
could mean a variety of things, so having a more specific name would be
beneficial.

> > Does this apply to vbat?
> Yes bat is read and then interpolation algorithm is applied for
> various power properties.
> So mapping from voltage to percentage is defined in table.
> >
> > Is vbat guaranteed to read in mV?
> Yes.
> >
> > Is any particular order required? The example seems to go be in
> > descending percentage values.
> There is done sorting in driver so ordering it's not necessary.
> >
> > Is any particular interpolation expected on behalf of the OS, or is this
> > just an informative set of measurements that hte OS can use as it sees
> > fit?
> >
> >> + - io-channels: Should contain IIO channel specifiers
> >> +     for each element in io-channel-names.
> >> +- io-channel-names: Should contain the following values:
> All 3 statements was copied from rx51-battery and documentation is the same.
> There is not unit for all channels just raw values which are then
> converted in driver.

I don't understand. How do you figure out the mapping of those raw
values to sensible units? Surely you need additional information to do
so?

Mark.
