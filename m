Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaL3Wq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:46:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45425 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaL3WqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:46:25 -0500
Date: Tue, 30 Dec 2014 23:46:22 +0100
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
	<linux-arm-kernel@lists.infradead.org>,
        eduardo.valentin@ti.com
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
Message-ID: <20141230224621.GA26163@amd>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-3-git-send-email-sre@kernel.org>
 <CANOLnON6rAQ2+jJEFDKseH2Htu6bqRkURDioGt7zp1Ze73f8Pw@mail.gmail.com>
 <CAGo_u6qO0ok+GBnm7SQtw6dJuwGN2OuP7CpKDEWawS3V2go4KA@mail.gmail.com>
 <20141229181556.GA26926@amd>
 <20141229190448.GA27124@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141229190448.GA27124@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-12-29 11:04:48, Guenter Roeck wrote:
> On Mon, Dec 29, 2014 at 07:15:56PM +0100, Pavel Machek wrote:
> > On Mon 2014-12-29 12:01:03, Nishanth Menon wrote:
> > > On Mon, Dec 29, 2014 at 11:52 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> > > > On Fri, Dec 26, 2014 at 2:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > > >> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> > > >> which can be used to determine the SoCs temperature. This patch provides
> > > >> a DT based driver for the temperature sensor based on an older driver
> > > >> written by Peter De Schrijver for the Nokia N900 and N9.
> > > >
> > > > The sensor looks like an earlier iteration of sensors used in newer
> > > > OMAPs, which are already supported by maybe
> > > > drivers/thermal/ti-soc-thermal/ , maybe it would make sense to update
> > > > that driver instead?
> > > 
> > > Just to be clear - OMAP4 is the first time that the sensors were
> > > reliable enough to be used.
> > 
> > When testing initial version of the patch, they seem to work very well
> > in the omap3 case.
> > 
> Pavel,
> 
> can you look into the omap4 thermal driver to see if it can be used ?

The hardware registers are named the same way...

Unfortunately, TI moves registers around with each release, and OMAP4
stuff is _way_ more complex and maze of ifdefs, too.

static struct temp_sensor_data omap4430_mpu_temp_sensor_data = {
        .min_freq = OMAP4430_MIN_FREQ,
 	.max_freq = OMAP4430_MAX_FREQ,
 	.max_temp = OMAP4430_MAX_TEMP,
	.min_temp = OMAP4430_MIN_TEMP,
 	.hyst_val = OMAP4430_HYST_VAL,
	};

and each define used just once. Would be easier to read and modify if
the ifdefs were removed...
	
Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
