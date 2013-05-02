Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab3EBL1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:27:45 -0400
Received: from sauhun.de ([89.238.76.85]:59841 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab3EBL1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:27:43 -0400
Date: Thu, 2 May 2013 13:27:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: linux-i2c@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: Re: Fwd: [PATCH v7] i2c: exynos5: add High Speed I2C controller
 driver
Message-ID: <20130502112721.GA7309@the-dreams.de>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1365137521-31187-1-git-send-email-naveenkrishna.ch@gmail.com>
 <20130416102902.GE16978@the-dreams.de>
 <CAHfPSqCe_VJMeH3oCDc0CfcmpawMj0hN7_b3ngHDFtDUsPJLsA@mail.gmail.com>
 <CAHfPSqC0E42+-oRfLoFCEe6CbV08fJQdkagvVYHaer4pJAU6pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHfPSqC0E42+-oRfLoFCEe6CbV08fJQdkagvVYHaer4pJAU6pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >> +  - Samsung GPIO variant (deprecated):
> >> +    - gpios: The order of the gpios should be the following: <SDA, SCL>.
> >> +      The gpio specifier depends on the gpio controller.
> >
> > Huh? Why should we support a deprecated method with a new driver?
> >

This was left unanswered. I am curious.

> >> +Optional properties:
> >> +  - samsung,hs-mode: Mode of operation, High speed or Fast speed mode. If not
> >> +    specified, default value is 0.
> >> +  - samsung,hs-clock-freq: Desired operating frequency in Hz of the bus.
> >> +    If not specified, the default value in Hz is 100000.
> >> +  - samsung,fs-clock-freq: Desired operarting frequency in Hz of the bus.
> >> +    If not specified, the default value in Hz is 100000.
> >
> > NACK! We have a generic binding for defining the bus speed. And
> > shouldn't hs-mode be set depending on the bus speed?

Please use "clock-frequency" here, like other drivers do.

> >> +     /* In auto mode the length of xfer cannot be 0 */
> >> +     if (i2c->msg->len == 0)
> >> +             i2c_auto_conf |= 0x1;
> >
> > So you send some byte then? Why not reject the message?
> This is to support the probing the devices (i2cdetect cases)

No! This is not a proper SMBUS_QUICK if you send a byte! If it doesn't
work without sending data, then your device does not support it. This is
not uncommon. Please check the smbus specs if you are unsure.

> >> +     i2c->regs = of_iomap(np, 0);
> >
> > devm_ioremap_resource()
> This was a comment from Thomas on v1.
> https://lkml.org/lkml/2012/11/27/264
> 
> Kindly, suggest me which one is more optimal in this case.

"Optimal" is difficult here, but devm_* has momentum and I prefer
consistency.

> Thanks for your valuable time and comments

You're welcome! Thanks for the submission.

   Wolfram

