Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935198AbaH0RDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:03:03 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:56159 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935094AbaH0RDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:03:00 -0400
Date: Wed, 27 Aug 2014 18:02:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v6 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140827170251.GB24579@lee--X1>
References: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
 <20140827133936.GD6364@lee--X1>
 <CAD=FV=WAN=WCdMd4hWDr8qzsg3TWTGX_OAa=6KHvyWrqjmk7MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=WAN=WCdMd4hWDr8qzsg3TWTGX_OAa=6KHvyWrqjmk7MA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Doug Anderson wrote:
> On Wed, Aug 27, 2014 at 6:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >> +static int rk808_probe(struct i2c_client *client,
> >> +                    const struct i2c_device_id *id)
> >> +{
> >> +     int ret;
> >> +     int pm_off = 0;
> >> +     struct rk808 *rk808;
> >> +     struct device_node *np = client->dev.of_node;
> >
> > Are you prepared for np == NULL?
> 
> Given that the driver no longer supports getting its config from
> platform data, I think it simply depends on OF now.  It seems like we
> could add a "&& OF" to the dependencies.  Is that OK with you?

If the driver depends on OF, then it should be specified in the Kconfig.

> It doesn't hurt to still add a check for np == NULL and bail out, though.

If we're depending on OF, then there's no real need to do this.

And of_property_read_bool() does a NULL check on np anyway, so not
checking is still okay.  I was just wondering if not checking was a
mistake or intentional?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
