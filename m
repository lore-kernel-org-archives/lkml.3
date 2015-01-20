Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbbATOQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:16:24 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45650 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbATOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:16:21 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-4c-54be633370da
Message-id: <1421763376.8855.4.camel@AMDC1943>
Subject: Re: [RFC PATCHv2 07/19] mfd: ab8500: Use power_supply_*() API for
 accessing function attrs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 20 Jan 2015 15:16:16 +0100
In-reply-to: <20150120133617.GG13701@x1>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
 <1420472882-10463-8-git-send-email-k.kozlowski@samsung.com>
 <20150120133617.GG13701@x1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xK7rGyftCDJa2G1pMevKe2WLiysnM
	Fve/HmW02PnwLZvF8n39jBabHl9jtbi8aw6bxefeI4wWd08dZbM4c/oSq8Xp3SUO3B47Z91l
	99i8Qstj06pONo871/aweWxeUu+x5Wo7i8eK1d/ZPT5vkgvgiOKySUnNySxLLdK3S+DKWPAp
	s2C2YMXltRfYGhjP8HYxcnJICJhIzPvdxA5hi0lcuLeeDcQWEljKKPHwR0wXIxeQ/ZlRonvp
	cxaQBK+AnsSJpx+YQGxhgVSJp1OvMYPYbALGEpuXLwFq5uAQEVCROPfGHKSXWeAJk0Tvukaw
	XhYBVYmOezvB6jkFNCTaNrczQSxYzCixuukt2FBmAXWJSfMWMYMMkhBQlmjsd4PYKyjxY/I9
	FogSeYnNa94yT2AUmIWkYxaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECImR
	rzsYlx6zOsQowMGoxMN7wnlviBBrYllxZe4hRgkOZiUR3rPm+0KEeFMSK6tSi/Lji0pzUosP
	MTJxcEo1MG6bev5R9n3fKdv+1aT2h5/Y23Us/H3gRpm8pO2mjlZXA47yibXf6OjZ2TX787lf
	MQtqZ2YqP5+y71rzPnOmuIvieo/is1ffFPGY5enxROZzYvG+Bel9v8NuV//+IWql2nDlN9fn
	qjuHRLZVqTPWHH350ql/2VK31cWMEXv0S5nCBO9+4LKboanEUpyRaKjFXFScCAAId1PAbwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2015-01-20 at 13:36 +0000, Lee Jones wrote:
> On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:
> 
> > Replace direct calls to power supply function attributes with wrappers.
> > Wrappers provide safe access in case of unregistering the power
> > supply (e.g. by removing the driver). Replace:
> >  - get_property -> power_supply_get_property
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> You've sent this to me already Acked.  I don't see 00/00, so I have no
> idea what's going on.  Do you want me to take this patch?  Can it be
> taking on its own?

git send-email automatically CC-you because you acked this. The depends
on previous patches adding this API so please do not pick it up. 

Everything (with respective acks) should go through one power supply
tree.

The same applies to patch 18/19.

Best regards,
Krzysztof

> 
> > ---
> >  drivers/mfd/ab8500-sysctrl.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
> > index cfff0b643f1b..d4a4b24be7c6 100644
> > --- a/drivers/mfd/ab8500-sysctrl.c
> > +++ b/drivers/mfd/ab8500-sysctrl.c
> > @@ -49,7 +49,8 @@ static void ab8500_power_off(void)
> >  		if (!psy)
> >  			continue;
> >  
> > -		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
> > +		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
> > +				&val);
> >  
> >  		if (!ret && val.intval) {
> >  			charger_present = true;
> > @@ -63,8 +64,8 @@ static void ab8500_power_off(void)
> >  	/* Check if battery is known */
> >  	psy = power_supply_get_by_name("ab8500_btemp");
> >  	if (psy) {
> > -		ret = psy->get_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY,
> > -					&val);
> > +		ret = power_supply_get_property(psy,
> > +				POWER_SUPPLY_PROP_TECHNOLOGY, &val);
> >  		if (!ret && val.intval != POWER_SUPPLY_TECHNOLOGY_UNKNOWN) {
> >  			printk(KERN_INFO
> >  			       "Charger \"%s\" is connected with known battery."
> 

