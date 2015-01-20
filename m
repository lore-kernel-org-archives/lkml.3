Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbbATQBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:01:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53465 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbATQBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:01:50 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-2a-54be7bede4a9
Message-id: <1421769706.1199.5.camel@AMDC1943>
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
Date: Tue, 20 Jan 2015 17:01:46 +0100
In-reply-to: <20150120155149.GG13701@x1>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
 <1420472882-10463-8-git-send-email-k.kozlowski@samsung.com>
 <20150120133617.GG13701@x1> <1421763376.8855.4.camel@AMDC1943>
 <20150120155149.GG13701@x1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xq7pvq/eFGEzaoGUx6cl7ZouJKycz
	W9z/epTRYufDt2wWy/f1M1psenyN1eLyrjlsFp97jzBa3D11lM3izOlLrBand5c4cHvsnHWX
	3WPzCi2PTas62TzuXNvD5rF5Sb3HlqvtLB4rVn9n9/i8SS6AI4rLJiU1J7MstUjfLoErY9GF
	A6wFEyQqrn4ob2DcI9TFyMkhIWAisfneMnYIW0ziwr31bF2MXBxCAksZJRYd38oO4XxmlGh+
	vxGsildAT+JF7x4mEFtYIFXi6dRrzCA2m4CxxOblS4C6OThEBFQkzr0xB+llFnjCJNG7rpEF
	pIZFQFVi8cerbCA2p4CGxMddt1ghFjxhlNjY8JIVJMEsoC4xad4iZpBBEgLKEo39bhB7BSV+
	TL7HAlEiL7F5zVvmCYwCs5B0zEJSNgtJ2QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsY
	IVHydQfj0mNWhxgFOBiVeHhPOO8NEWJNLCuuzD3EKMHBrCTCK1C+L0SINyWxsiq1KD++qDQn
	tfgQIxMHp1QD4+5LAUW1pryP0nS+Xrmn4zBh9pIDXuc19vzc/yf/0ryydl2HnrrpRyKecrS0
	r0hoY96SfeCRAsvTM3z77XU9FC6XSfhP2B7S0qAiOl81+vySJ3sVc27bW8d3BBV7P07s/Srq
	OCVb6rjaPqcdEZLnpy1XZnqhvUOxtYzpsEhDvv45RyWZmyxNSizFGYmGWsxFxYkAUGBYgnAC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2015-01-20 at 15:51 +0000, Lee Jones wrote:
> On Tue, 20 Jan 2015, Krzysztof Kozlowski wrote:
> 
> > On wto, 2015-01-20 at 13:36 +0000, Lee Jones wrote:
> > > On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:
> > > 
> > > > Replace direct calls to power supply function attributes with wrappers.
> > > > Wrappers provide safe access in case of unregistering the power
> > > > supply (e.g. by removing the driver). Replace:
> > > >  - get_property -> power_supply_get_property
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
> > > > Acked-by: Pavel Machek <pavel@ucw.cz>
> > > > Acked-by: Lee Jones <lee.jones@linaro.org>
> > > 
> > > You've sent this to me already Acked.  I don't see 00/00, so I have no
> > > idea what's going on.  Do you want me to take this patch?  Can it be
> > > taking on its own?
> > 
> > git send-email automatically CC-you because you acked this. The depends
> > on previous patches adding this API so please do not pick it up. 
> 
> You should always send MFD related patches to me (either
> automatically, or manually).
> 
> > Everything (with respective acks) should go through one power supply
> > tree.
> 
> That's not how it works.  We need to decide that amongst ourselves
> and it needs to culminate in pull-requests being sent out to all of
> the effected Maintainers.

OK, I understand. My reply sounded kind a imperative but that was not
what I wanted to say... The patchset adds some API first so most of
patches cannot be picked independently.

Thank you for proactive concern about the patch.

Best regards,
Krzysztof

> 
> > The same applies to patch 18/19.
> > 
> > Best regards,
> > Krzysztof
> > 
> > > 
> > > > ---
> > > >  drivers/mfd/ab8500-sysctrl.c | 7 ++++---
> > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
> > > > index cfff0b643f1b..d4a4b24be7c6 100644
> > > > --- a/drivers/mfd/ab8500-sysctrl.c
> > > > +++ b/drivers/mfd/ab8500-sysctrl.c
> > > > @@ -49,7 +49,8 @@ static void ab8500_power_off(void)
> > > >  		if (!psy)
> > > >  			continue;
> > > >  
> > > > -		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
> > > > +		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
> > > > +				&val);
> > > >  
> > > >  		if (!ret && val.intval) {
> > > >  			charger_present = true;
> > > > @@ -63,8 +64,8 @@ static void ab8500_power_off(void)
> > > >  	/* Check if battery is known */
> > > >  	psy = power_supply_get_by_name("ab8500_btemp");
> > > >  	if (psy) {
> > > > -		ret = psy->get_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY,
> > > > -					&val);
> > > > +		ret = power_supply_get_property(psy,
> > > > +				POWER_SUPPLY_PROP_TECHNOLOGY, &val);
> > > >  		if (!ret && val.intval != POWER_SUPPLY_TECHNOLOGY_UNKNOWN) {
> > > >  			printk(KERN_INFO
> > > >  			       "Charger \"%s\" is connected with known battery."
> > > 
> > 
> 

