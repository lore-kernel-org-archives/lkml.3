Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbbARUdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 15:33:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34972 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbARUds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 15:33:48 -0500
Date: Sun, 18 Jan 2015 21:33:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Nishanth Menon <nm@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        dt list <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Jean Delvare <jdelvare@suse.de>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
Message-ID: <20150118203346.GA29863@amd>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-3-git-send-email-sre@kernel.org>
 <CANOLnON6rAQ2+jJEFDKseH2Htu6bqRkURDioGt7zp1Ze73f8Pw@mail.gmail.com>
 <CAGo_u6qO0ok+GBnm7SQtw6dJuwGN2OuP7CpKDEWawS3V2go4KA@mail.gmail.com>
 <20141229181556.GA26926@amd>
 <20141229190448.GA27124@roeck-us.net>
 <20150103091858.GA30538@amd>
 <20150107161944.GB9012@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107161944.GB9012@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2015-01-07 08:19:44, Guenter Roeck wrote:
> On Sat, Jan 03, 2015 at 10:18:58AM +0100, Pavel Machek wrote:
> > On Mon 2014-12-29 11:04:48, Guenter Roeck wrote:
> > > On Mon, Dec 29, 2014 at 07:15:56PM +0100, Pavel Machek wrote:
> > > > On Mon 2014-12-29 12:01:03, Nishanth Menon wrote:
> > > > > On Mon, Dec 29, 2014 at 11:52 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> > > > > > On Fri, Dec 26, 2014 at 2:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > > > > >> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> > > > > >> which can be used to determine the SoCs temperature. This patch provides
> > > > > >> a DT based driver for the temperature sensor based on an older driver
> > > > > >> written by Peter De Schrijver for the Nokia N900 and N9.
> > > > > >
> > > > > > The sensor looks like an earlier iteration of sensors used in newer
> > > > > > OMAPs, which are already supported by maybe
> > > > > > drivers/thermal/ti-soc-thermal/ , maybe it would make sense to update
> > > > > > that driver instead?
> > > > > 
> > > > > Just to be clear - OMAP4 is the first time that the sensors were
> > > > > reliable enough to be used.
> > > > 
> > > > When testing initial version of the patch, they seem to work very well
> > > > in the omap3 case.
> > > > 
> > > Pavel,
> > > 
> > > can you look into the omap4 thermal driver to see if it can be used ?
> > 
> > After some fixes... yes, it seems to be same hardware.
> > 
> So this should be the way to go, but then we have others claim that
> it should not be done because the OMAP3 sensors are too unreliable
> to use for thermal decisions. Not really sure where that leaves us.
> I am kind of opposed to have similar drivers for similar chips
> in two different subsystems.
> 
> Is it possible to add the patch below to the omap thermal driver
> and not use it for thermal decisions ?

Well... noone forces you to enable the driver, and I don't think it
will do any thermal decisions on N900 as it is ... so we should be ok.

Plus, it seems to work reasonably well (say +- 5 C), so situation does
not seem to be as bad as TI claims.

Nokia was actually using it in production.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
