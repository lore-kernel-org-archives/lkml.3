Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3AOFiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 00:38:20 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:47522 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3AOFiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 00:38:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Vxdjo5aOU25a-iDNDaiGZCu0+G-p5y1NifXHUJBF0AHg@mail.gmail.com>
References: <1357891738-26259-1-git-send-email-gautam.vivek@samsung.com>
	<CAD=FV=Vxdjo5aOU25a-iDNDaiGZCu0+G-p5y1NifXHUJBF0AHg@mail.gmail.com>
Date: Tue, 15 Jan 2013 11:08:16 +0530
Message-ID: <CAFp+6iE7zEJ7E_pRCOYz5mQqbk-MFE6Hwr02pRRT1yP+X3z7kQ@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung: Add support to set pmu isolation
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, l.majewski@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Praveen Paneri <p.paneri@samsung.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        balbi@ti.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,


On Tue, Jan 15, 2013 at 3:41 AM, Doug Anderson <dianders@chromium.org> wrote:
> Vivek,
>
> Sorry for being so absent from these reviews.  I'll try to look over a
> few patches today, but please don't hold up anything on account of my
> reviews.  I'm definitely a bit of an interested bystander in USB land.
>  ;)
>
> In general things look pretty good here.  :)  One last comment below...
>
> On Fri, Jan 11, 2013 at 12:08 AM, Vivek Gautam
> <gautam.vivek@samsung.com> wrote:> +static int
> samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
>> +{
>> +       struct device_node *usbphy_sys;
>> +
>> +       /* Getting node for system controller interface for usb-phy */
>> +       usbphy_sys = of_get_child_by_name(sphy->dev->of_node, "usbphy-sys");
>> +       if (!usbphy_sys)
>> +               dev_warn(sphy->dev, "No sys-controller interface for usb-phy\n");
>
> Seems like you ought to return with an error here.  Calling of_iomap()
> with a NULL value seems undesirable.
>

Yeah, true. This should have been returning error value alongwith dev_err().

>> +
>> +       sphy->pmuregs = of_iomap(usbphy_sys, 0);
>> +
>> +       of_node_put(usbphy_sys);
>> +
>> +       if (sphy->pmuregs == NULL) {
>> +               dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Set isolation here for phy.
>> + * Here 'on = true' would mean USB PHY block is isolated, hence
>> + * de-activated and vice-versa.
>> + */
>
> Thank you very much for this comment.  :)  This explains one of the
> confusions I had earlier...
>
Your welcome :-)
>
> Once you fix the one error condition above you can add my
> "Reviewed-by".  Thanks!
>
Sure, thanks !!



-- 
Thanks & Regards
Vivek
