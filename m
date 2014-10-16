Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaJPMlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:41:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52969 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaJPMlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:41:19 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9e-543fbcece870
Message-id: <1413463274.18828.1.camel@AMDC1943>
Subject: Re: [PATCH v2 7/7] mfd: ab8500: Decrement the power supply's device
 reference counter
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
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
Date: Thu, 16 Oct 2014 14:41:14 +0200
In-reply-to: <20141016122901.GA22725@lee--X1>
References: <1413445327-24862-1-git-send-email-k.kozlowski@samsung.com>
 <1413445327-24862-8-git-send-email-k.kozlowski@samsung.com>
 <20141016122901.GA22725@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA03RW0iTYRjAcd99+w6uRm9L54sXJjOxLDVJ8qVEC6G+i6g0Desmpw4nbLo2
	ZxmSS7woxTylxJQxj5vLUDctz9jQZprSSaFIpeYuAnUtrRmY5dqNd38efg/PxcMQgl5uIJOT
	my9R5oplIorHnd62zUesDCekHNfohfhF3xHc87iLxK0lUlyz7CRwdUctget7AnB7iwPgmZIV
	Gi/9nAD40ZaBg832eRK/H2yk8HrFOMCutm4SPx1foPG7MT0HL0xNUNhuXKXxdDmJp4fyscVc
	R+DNbjt5RshWVf4A7IB2gWb1ZjVrMYazLcPfOKzZ9IBiP88PU+za7CzN6l4lsZbWYtbl+MRl
	naNzFPuw1wRY4xM3za6bg9jJ0g3yMrzOi8uSyHIKJMqo+HSedNvhoBRLvNvbvxppDehiyoAv
	g2AMKhm3cb0tRG8WuyhPC2AbQF/77np7HaDS50Ge5sMopGnq/u8PwHQ01T9IeJqCJ5DF0Lqz
	yzB+8BCaXYktAzyGgGYKtc81kB7DhaGoeq6X6zG+MAJZrFKPEUAjQHV1Q7THEDAM1eiaCY9B
	MATdqzznPbsfbdYucr3kILJ0rhJVAGp3bWh3Me0upgeECfhL1JkKVUa2PDpSJZar1LnZkZl5
	cjPwfnqjH7S8PGUFkAGivfzDVxJSBKS4QFUotwLEECI/fnPNzoifJS68I1Hm3VCqZRKVFXAY
	30ANuHWVHrT7B4M4V84W+XF0LcMALoamvSb9nDOZezKaEkUG0+L3gLG0Y7aQy1TyhSDV5J+i
	5POwMmbsrEx3NF9R2BFfDJWb1+zhUcJOjUvoPumzbIwrKFK43ftGkr6kIt2lm6f198Ni7f22
	kfLEZxVvlRV/fWZSfw8Ef3BuNNSLuCqpODqcUKrE/wBQhHOKxwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-10-16 at 14:29 +0200, Lee Jones wrote:
> On Thu, 16 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > Use power_supply_put() to decrement the power supply's device reference
> > counter.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> I already Acked this.

I think you acked mfd change in my first patchset
(power_supply_get_property()):
	[PATCH 5/8] mfd: ab8500: Use power_supply_*() API for accessing
function attrs

... and this is my second patchset with other API (power_supply_put).

Best regards,
Krzysztof


> 
> > ---
> >  drivers/mfd/ab8500-sysctrl.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
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

