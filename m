Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3J2Ne2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:34:28 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38662 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3J2Ne0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:34:26 -0400
MIME-Version: 1.0
In-Reply-To: <20131024124631.GA14517@mtj.dyndns.org>
References: <20131024124631.GA14517@mtj.dyndns.org>
Date: Tue, 29 Oct 2013 14:34:26 +0100
Message-ID: <CACRpkdY2d88RxxgZ5=rPuQHrb3a7Q+trvBWsEMSaByhtWKf31Q@mail.gmail.com>
Subject: Re: READ/WRITE definitions in drivers/spi/spi-omap-100k.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Tejun Heo <tj@kernel.org>, Mark Brown <broonie@kernel.org>,
        darkstar6262@gmail.com
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 2:46 PM, Tejun Heo <tj@kernel.org> wrote:

> Hey, guys.
>
> I was modifying includes in a core header file and got duplicate macro
> definition warnings on READ / WRITE in drivers/spi/spi-omap-100k.c.
> Apparently that driver defines READ / WRITE as macros and assigns the
> opposite values to them from the usual READ / WRITE constants defined
> in include/linux/fs.h.
>
> I just skimmed through it and there doesn't seem to be any user of the
> macros.  Can we *please* remove these?  Please note that READ / WRITE
> defined in include/linux/fs.h is something which is widely used
> throughout the kernel and there are multiple interfaces which take
> those constants.  Re-defining them in the other way around in a driver
> file can lead to subtle issues and just is a bad idea.  In general,
> refraining from using generic symbols without any qualitification in
> low level drivers would be nice.

That seems like a good idea, but we better poke the people who wrote
the code and the SPI maintainer :-)

Yours,
Linus Walleij
