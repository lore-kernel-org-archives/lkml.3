Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaKJVtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:49:14 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41404 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaKJVtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:49:12 -0500
Date: Mon, 10 Nov 2014 22:46:58 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v2 1/2] i2c: add support for Amlogic Meson I2C controller
Message-ID: <20141110214658.GA15156@gmail.com>
References: <1412540232-26168-1-git-send-email-b.galvani@gmail.com>
 <1412540232-26168-2-git-send-email-b.galvani@gmail.com>
 <20141110144440.GB10422@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110144440.GB10422@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:44:41PM +0100, Wolfram Sang wrote:
> On Sun, Oct 05, 2014 at 10:17:11PM +0200, Beniamino Galvani wrote:
> > This is a driver for the I2C controller found in Amlogic Meson SoCs.
> > 
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> 
> Thanks. Looking very good already!
> 
> > +static void meson_i2c_prepare_xfer(struct meson_i2c *i2c, bool write)
> 
> Instead of the bool, maybe you could query i2c->state in the function?
> You decide, I am not forcing you to do this.

Seems reasonable, will do.

> 
> > +static u32 meson_i2c_func(struct i2c_adapter *adap)
> > +{
> > +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> > +}
> 
> Have you tested 0-byte transfers, too (i2cdetect -q)? What was your test
> scenario in general?

I did a test with i2cdetect and quick write commands appear to
work.

When I wrote the driver I tested it to communicate with the only I2C
device available on the board, a Ricoh RN5T618 PMIC.

Now I have access to a hardware with a PCF8564 RTC and just realized
that long reads don't work properly, so I'm going to submit a new
version of the patchset in the next days.

Thanks,
Beniamino
