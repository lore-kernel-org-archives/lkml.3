Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbbAOSQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:16:46 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36471 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbbAOSQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:16:43 -0500
Date: Thu, 15 Jan 2015 10:16:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-input@vger.kernel.org, Marek Belisko <marek@goldelico.com>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Yoichi Yuasa <yuasa@linux-mips.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Subject: Re: [PATCH 1/3] input: tsc2007: Add pre-calibration, flipping and
 rotation
Message-ID: <20150115181637.GE33214@dtor-ws>
References: <1412108254-19234-1-git-send-email-marek@goldelico.com>
 <1412108254-19234-2-git-send-email-marek@goldelico.com>
 <CAAfyv36bD9ZratOzr7FkeQde8k-K9XjEjH9gkntm9qewD-cH9g@mail.gmail.com>
 <20150115005938.GB9134@dtor-ws>
 <0F9A17C1-9B01-4EE9-BE98-266B8FC02B84@goldelico.com>
 <20150115143855.GD512@earth.universe>
 <8B08216C-13DD-40D8-9BA9-060F1C18A018@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8B08216C-13DD-40D8-9BA9-060F1C18A018@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 05:14:38PM +0100, Dr. H. Nikolaus Schaller wrote:
> 
> Am 15.01.2015 um 15:38 schrieb Sebastian Reichel <sre@kernel.org>:
> 
> > Hi,
> > 
> > On Thu, Jan 15, 2015 at 08:36:44AM +0100, Dr. H. Nikolaus Schaller wrote:
> >>> 1. Perform conversion in input core rather than individual drivers. I
> >>> think we should allocate a new bitmaps for some transformations and have
> >>> the code do X/Y flip/clip of the coordinates.
> >> 
> >> Do you have a suggestion where this should be (I have no clue how
> >> the input system works or is structured - we just know how to extend a
> >> driver that uses it)?
> >> 
> >>> 2. Standardize on bindings. We already have of-touchscreen.c doing
> >>> rudimentary parsing, we shoudl look into extending it rather than
> >>> creating myriad of driver-specific bindings.
> >> 
> >> Ok, looks reasonable.
> > 
> > Documentation is in 
> > 
> > Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
> 
> I did look into it now. Unfortunately, it does not fit well into my view of how bindings
> should be. They should describe hardware (as we are told for many other kernel
> subsystems).
> 
> Pixels and resolutions are IMHO related to the screen it is glued on - and that is
> quite independent.

Well, I think pixels was the wrong word to be used there. It is meant to
be native units, as opposed to millimeters, inches, points, etc.

> 
> So I don’t see how they do describe the different ways the touch screen can be
> wired to a tsc2007 controller.
> 
> Please can you add minimum and maximum properties for us?
> 
> Then, inverted-x and inverted-y is redundant because it is the same as having
> an expected higher value from the ADC for the minimum coordinate and a lower
> for the maximum.

I'd rather not add minimum and maximum, but add the touchscreen-start-x and
touchscreen-start-y instead so that we limit the number of obsolete
properties.

Thanks.

-- 
Dmitry
