Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbbAOA7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:59:46 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44053 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbAOA7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:59:44 -0500
Date: Wed, 14 Jan 2015 16:59:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-input@vger.kernel.org, Marek Belisko <marek@goldelico.com>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Yoichi Yuasa <yuasa@linux-mips.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 1/3] input: tsc2007: Add pre-calibration, flipping and
 rotation
Message-ID: <20150115005938.GB9134@dtor-ws>
References: <1412108254-19234-1-git-send-email-marek@goldelico.com>
 <1412108254-19234-2-git-send-email-marek@goldelico.com>
 <CAAfyv36bD9ZratOzr7FkeQde8k-K9XjEjH9gkntm9qewD-cH9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv36bD9ZratOzr7FkeQde8k-K9XjEjH9gkntm9qewD-cH9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 03:15:39PM +0100, Belisko Marek wrote:
> Ping for input maintainer. DT changes was acked. Thanks.
> 
> On Tue, Sep 30, 2014 at 10:17 PM, Marek Belisko <marek@goldelico.com> wrote:
> > This patch adds new parameters that allow to address typical hardware
> > design differences: touch screens may be wired or oriented differently
> > (portrait or landscape). And usually the active area of the touch is a
> > little larger than the active area of the LCD. This results in the touch
> > coordinates that have some significant deviation from LCD coordinates.
> > Usually this is addressed in user space by a calibration tool (e.g. tslib
> > or xinput-calibrator) but some systems don't have these tools or require
> > that the screen is already roughly calibrated (e.g. Replicant) to operate
> > the device until a better calibration can be done. And, some systems
> > react very strangely if the touch event stream reports coordinates
> > outside of the active area.
> >
> > This makes it necessry to be able to configure:
> > 1. swapping x and y wires (coordinate values)
> > 2. flipping of x (left - right) or y (top - bottom) or even both
> > 3. define an active area so that an uncalibrated screen already
> > roughly matches the LCD to be useful.
> > 4. clip reported coordinates to the active area.
> >
> > If none of the new parameters is defined (in DT) or set in a board file,
> > the driver behaves the same as without this patch.
> >
> > Author (1&2): H. Nikolaus Schaller <hns@goldelico.com>
> > Author (3&4): Paul Kocialkowski <contact@paulk.fr>
> >
> > Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

OK, I was hesitant of adding these as normally we have tslib to perform
the conversion, but maybe it is time to allow it in the kernel and
standardize users. However, this seems like a general issue and we
should:

1. Perform conversion in input core rather than individual drivers. I
think we should allocate a new bitmaps for some transformations and have
the code do X/Y flip/clip of the coordinates.

2. Standardize on bindings. We already have of-touchscreen.c doing
rudimentary parsing, we shoudl look into extending it rather than
creating myriad of driver-specific bindings.

Also, do we need swap and flip or do we simply need rotation (like the
proposed Broadcom iproc driver has)?

Thanks.

-- 
Dmitry
