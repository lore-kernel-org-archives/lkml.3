Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaE3HmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:42:18 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51963 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaE3HmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:42:15 -0400
Message-ID: <1401435691.13544.3.camel@iivanov-dev>
Subject: Re: [PATCH v2] pinctrl: Enable "power-source" to be extracted from
 DT files
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 May 2014 10:41:31 +0300
In-Reply-To: <CACRpkdYR9cZOnG2r3Kh027LNKgsDJqxL0J9Gryu+JHXacTNHbQ@mail.gmail.com>
References: <CACRpkdZyLxMTSygRP6pD-mxghQ_D6tQ821tvn8GYw0Rnh9hZoQ@mail.gmail.com>
	 <2480893.UEqfxe8meR@phil>
	 <CACRpkdbaWYgku0_n5CqGU8DAFnn-5jEJ64Mfh9fixB4mRPnfwg@mail.gmail.com>
	 <1943407.eJZOu7V4pT@phil>
	 <CACRpkdYR9cZOnG2r3Kh027LNKgsDJqxL0J9Gryu+JHXacTNHbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 10:48 +0200, Linus Walleij wrote:
> On Wed, May 28, 2014 at 10:36 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > Am Mittwoch, 28. Mai 2014, 10:15:43 schrieb Linus Walleij:
> >> On Tue, May 27, 2014 at 3:09 PM, Heiko Stübner <heiko@sntech.de> wrote:
> >> > Am Dienstag, 27. Mai 2014, 09:27:36 schrieb Ivan T. Ivanov:
> >> >> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >> >>
> >> >> Add "power-source" property to generic options used for DT parsing files.
> >> >> This  enables drivers, which use generic pin configurations, to get the
> >> >> value passed to this property.
> >> >
> >> > I think the main problem here is, that pinconf-generic.h defines the
> >> > power-
> >> > source as having a "custom format". With DT as a hardware description,
> >> > implementaton specific values do not work well - instead it should have a
> >> > regular unit-value.
> >> >
> >> > For the power-source I think volts could work well - as this is the main
> >> > use- case for pinctrl I know. The regulator-binding uses microvolts,
> >> > maybe it would be good use a similar unit.
> >>
> >> (...)
> >>
> >> >         pcfg_1v8 {
> >> >
> >> >                 power-source = <1800000>;
> >> >
> >> >         };
> >>
> >> I don't think this is what it's meant for actually. In this case the thing
> >> would be modeled as a regulator rather than some pin control option I
> >> guess?
> >>
> >> I think it's more like a selector, such as found on old amplifiers,
> >> input source A, B or C? So it's just some discrete number.
> >
> > as I said, you know this better than me ;-)
> >
> > I was thinking more of these io-voltages, where one can select between say 1.8
> > and 3.3V for the pins.
> >
> > I have this somewhere on my todo list for the rockchips too.
> >
> > So essentially the pinctrl driver [as it is a pin-group specific setting]
> > should just export regulators for these voltage settings, without touching the
> > pinconfig itself, right?
> 
> Hm hm hm.
> 
> I am a bit in the blue actually.
> 
> I think we need to have a discussion with Mark Brown on how to
> handle this.
> 
> We have previously had the case of MMC/SD level-shifters, where
> a certain setting gives a certain level of signals out, and another setting
> gives another level. Like two discrete levels.
> 
> So we modeled that as a regulator provider inside the pin control
> driver eventually, see sh-pfc/pfc-sh73a0.c
> 
> But this is different: it is the power of the pin itself.
> 
> I can think of a "padring regulator" hooking in as part of the pin state
> but have no clear idea on how to actually do that. We need some
> coding I think.
> 

In my case this is just a switch, which can select from different power
sources and these sources are external from the chip. So I can't know
a priory what the levels are and hard code them inside the driver.

Thanks,
Ivan


