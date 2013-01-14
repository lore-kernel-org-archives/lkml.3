Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab3ANWLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:11:48 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:51565 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab3ANWLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:11:47 -0500
MIME-Version: 1.0
In-Reply-To: <1357891738-26259-1-git-send-email-gautam.vivek@samsung.com>
References: <1357891738-26259-1-git-send-email-gautam.vivek@samsung.com>
Date: Mon, 14 Jan 2013 14:11:42 -0800
Message-ID: <CAD=FV=Vxdjo5aOU25a-iDNDaiGZCu0+G-p5y1NifXHUJBF0AHg@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung: Add support to set pmu isolation
From: Doug Anderson <dianders@chromium.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, gregkh@linuxfoundation.org,
        balbi@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>, t.figa@samsung.com,
        Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        l.majewski@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Praveen Paneri <p.paneri@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek,

Sorry for being so absent from these reviews.  I'll try to look over a
few patches today, but please don't hold up anything on account of my
reviews.  I'm definitely a bit of an interested bystander in USB land.
 ;)

In general things look pretty good here.  :)  One last comment below...

On Fri, Jan 11, 2013 at 12:08 AM, Vivek Gautam
<gautam.vivek@samsung.com> wrote:> +static int
samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
> +{
> +       struct device_node *usbphy_sys;
> +
> +       /* Getting node for system controller interface for usb-phy */
> +       usbphy_sys = of_get_child_by_name(sphy->dev->of_node, "usbphy-sys");
> +       if (!usbphy_sys)
> +               dev_warn(sphy->dev, "No sys-controller interface for usb-phy\n");

Seems like you ought to return with an error here.  Calling of_iomap()
with a NULL value seems undesirable.

> +
> +       sphy->pmuregs = of_iomap(usbphy_sys, 0);
> +
> +       of_node_put(usbphy_sys);
> +
> +       if (sphy->pmuregs == NULL) {
> +               dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * Set isolation here for phy.
> + * Here 'on = true' would mean USB PHY block is isolated, hence
> + * de-activated and vice-versa.
> + */

Thank you very much for this comment.  :)  This explains one of the
confusions I had earlier...


Once you fix the one error condition above you can add my
"Reviewed-by".  Thanks!

-Doug
