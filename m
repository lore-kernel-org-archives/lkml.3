Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaF0KTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:19:49 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:65123 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaF0KTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:19:46 -0400
Date: Fri, 27 Jun 2014 11:19:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jim Davis <jim.epost@gmail.com>, sfr@canb.auug.org.au,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, sbkim73@samsung.com,
        sameo@linux.intel.com, grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: mfd: sec-core requires regulators
Message-ID: <20140627101940.GJ19645@lee--X1>
References: <CA+r1ZhhFYip3Jp2c3d8tNpD-vK8Pkf7DzrKTtk6Gy8uOOO3Ucw@mail.gmail.com>
 <29237234.T7oGEGKuvp@wuerfel>
 <20140624154833.GR13803@lee--X1>
 <6906564.1ehoeq1QjB@wuerfel>
 <20140627090957.GG19645@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140627090957.GG19645@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014, Lee Jones wrote:

> On Tue, 24 Jun 2014, Arnd Bergmann wrote:
> 
> > The newly added sec-core mfd module calls the regulator_suspend_prepare()
> > function, which is only available if the regulator API is provided. This
> > matches the usage of the driver, so we can just add a Kconfig dependency.
> > 
> > Reported-by: Jim Davis <jim.epost@gmail.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Thanks for re-sending Arnd, patch applied.

Slight change of plan - this appears to have been fixed by 591123e.

> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 207c433..1caa3c5 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -582,7 +582,7 @@ config MFD_RC5T583
> >  
> >  config MFD_SEC_CORE
> >         bool "SAMSUNG Electronics PMIC Series Support"
> > -       depends on I2C=y
> > +       depends on I2C=y && REGULATOR
> >         select MFD_CORE
> >         select REGMAP_I2C
> >         select REGMAP_IRQ
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
