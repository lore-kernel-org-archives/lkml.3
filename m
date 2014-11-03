Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaKCSBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:01:12 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:58578 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaKCSBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:01:07 -0500
Date: Mon, 3 Nov 2014 18:00:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Pavel Machek <pavel@ucw.cz>, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 7/7] mfd: ab8500: Decrement the power supply's device
 reference counter
Message-ID: <20141103180059.GW12011@x1>
References: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
 <1413290117-13082-8-git-send-email-k.kozlowski@samsung.com>
 <20141103175945.GV12011@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141103175945.GV12011@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014, Lee Jones wrote:

> On Tue, 14 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > Use power_supply_put() to decrement the power supply's device reference
> > counter.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/ab8500-sysctrl.c | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> Applied, thanks.

Whoops, to hasty there -- unapplied.

What's going on with this set?

> > diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
> > index 93b2d2c32ca3..d05a5719cfc4 100644
> > --- a/drivers/mfd/ab8500-sysctrl.c
> > +++ b/drivers/mfd/ab8500-sysctrl.c
> > @@ -51,6 +51,7 @@ static void ab8500_power_off(void)
> >  
> >  		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
> >  				&val);
> > +		power_supply_put(psy);
> >  
> >  		if (!ret && val.intval) {
> >  			charger_present = true;
> > @@ -73,6 +74,7 @@ static void ab8500_power_off(void)
> >  			       pss[i]);
> >  			machine_restart("charging");
> >  		}
> > +		power_supply_put(psy);
> >  	}
> >  
> >  shutdown:
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
