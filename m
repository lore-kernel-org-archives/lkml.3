Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3LAWcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 17:32:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57667 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3LAWcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 17:32:08 -0500
Date: Sun, 1 Dec 2013 14:26:59 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: jonghwa3.lee@samsung.com
Cc: Austin Boyle <boyle.austin@gmail.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] max17042: Fix build errors caused by missing REGMAP_I2C
 config
Message-ID: <20131201222659.GC6271@lizard>
References: <20131124214149.cf1b6444d6e43d637ea7e34b@gmail.com>
 <52929C64.2090903@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52929C64.2090903@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 09:40:04AM +0900, jonghwa3.lee@samsung.com wrote:
> > max17042 now uses regmap interface but does not enable config option. This patch fixes the following build errors:
> > 
> > drivers/power/max17042_battery.c:661:15: error: variable ‘max17042_regmap_config’ has initializer but incomplete type
> > 
> > Signed-off-by: Austin Boyle <boyle.austin@gmail.com>
> > ---
> > diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> > index 5e2054a..85ad58c 100644
> > --- a/drivers/power/Kconfig
> > +++ b/drivers/power/Kconfig
> > @@ -196,6 +196,7 @@ config BATTERY_MAX17040
> >  config BATTERY_MAX17042
> >  	tristate "Maxim MAX17042/17047/17050/8997/8966 Fuel Gauge"
> >  	depends on I2C
> > +	select REGMAP_I2C
> >  	help
> >  	  MAX17042 is fuel-gauge systems for lithium-ion (Li+) batteries
> >  	  in handheld and portable equipment. The MAX17042 is configured
> 
> Sorry, It's my fault. Thanks.
> 
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

Applied, thanks!
