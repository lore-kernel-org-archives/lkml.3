Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaIPXF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:05:56 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64220 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaIPXFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:05:54 -0400
Date: Tue, 16 Sep 2014 16:05:37 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Nishanth Menon <nm@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: twl4030-power: use 'ti,system-power-controller'
 as alternative way to support system power off
Message-ID: <20140916230537.GU25162@lee--X1>
References: <1409771208-21867-1-git-send-email-nm@ti.com>
 <1409771208-21867-3-git-send-email-nm@ti.com>
 <20140909000126.GU3238@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140909000126.GU3238@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2014, Tony Lindgren wrote:

> * Nishanth Menon <nm@ti.com> [140903 12:07]:
> > ti,system-power-controller is more or less the standard way of
> > indicating that the PMIC is the system wide power controller and hence
> > may be used to switch off the system. Almost ALL TI PMIC drivers and
> > many Maxim PMIC drivers follow the same style.
> > 
> > So support 'ti,system-power-controller' in addition to the usual
> > 'ti,use_poweroff' to indicate that the PMIC instance has control for
> > switching off the system.
> > 
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

I assume you're going to resend this with the document modifications?
When you do, don't forget to apply Tony's Ack, as it will ensure a
faster merge.

> > ---
> >  drivers/mfd/twl4030-power.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> > index 3bc969a..1c129ba 100644
> > --- a/drivers/mfd/twl4030-power.c
> > +++ b/drivers/mfd/twl4030-power.c
> > @@ -627,6 +627,9 @@ static bool twl4030_power_use_poweroff(const struct twl4030_power_data *pdata,
> >  	if (pdata && pdata->use_poweroff)
> >  		return true;
> >  
> > +	if (of_property_read_bool(node, "ti,system-power-controller"))
> > +		return true;
> > +
> >  	if (of_property_read_bool(node, "ti,use_poweroff"))
> >  		return true;
> >  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
