Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaBNP2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:28:47 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45183 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:28:45 -0500
Date: Fri, 14 Feb 2014 15:28:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add devicetree support.
Message-ID: <20140214152838.GA30687@lee--X1>
References: <1392383861-14169-1-git-send-email-marek@goldelico.com>
 <20140214134815.GD13293@lee--X1>
 <CAAfyv36FH364OPnktx_Qh6sUfwYe7hynqrc3Xs_tY4gPXqQWvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAfyv36FH364OPnktx_Qh6sUfwYe7hynqrc3Xs_tY4gPXqQWvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Signed-off-by: Marek Belisko <marek@goldelico.com>
> >> ---
> >>  .../devicetree/bindings/mfd/twl4030-madc.txt       | 18 +++++++++++++
> >>  drivers/mfd/twl4030-madc.c                         | 31
> >> ++++++++++++++++++++--
> >
<snip>

> >> +static struct twl4030_madc_platform_data *
> >> +     twl4030_madc_of_parse(struct platform_device *pdev)
> >> +{
> >> +     struct twl4030_madc_platform_data *pdata;
> >> +
> >> +     pdata = devm_kzalloc(&pdev->dev,
> >> +                     sizeof(struct twl4030_madc_platform_data), GFP_KERNEL);
> >
> > s/struct twl4030_madc_platform_data/*pdata/
> Right typo.

Sorry, my comment of ambiguous.

I mean do this:

  sizeof(*pdata)

... instead of this:

  sizeof(struct twl4030_madc_platform_data)

> >> +     if (!pdata)
> >> +             return ERR_PTR(-ENOMEM);
> >> +
> >> +     pdata->irq_line = platform_get_irq(pdev, 0);
> >
> > Why weren't 'resources' used in the original implementation?
> Not sure I'm not an author :). It's passed in platform data.

Yes, I saw that. It should be changed.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
