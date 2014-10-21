Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbaJUM3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:29:34 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41267 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaJUM3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:29:33 -0400
Message-ID: <544651A5.8080601@collabora.co.uk>
Date: Tue, 21 Oct 2014 14:29:25 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v2 1/4] regulator: max77686: Replace hard-coded opmode
 values with defines
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com> <1413890597-31037-2-git-send-email-k.kozlowski@samsung.com> <54464A37.6060701@collabora.co.uk> <1413894170.31665.9.camel@AMDC1943>
In-Reply-To: <1413894170.31665.9.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/21/2014 02:22 PM, Krzysztof Kozlowski wrote:
> On wto, 2014-10-21 at 13:57 +0200, Javier Martinez Canillas wrote:
>> >  
>> > +/* On/off controlled by PWRREQ */
>> > +#define MAX77686_OPMODE_OFF_PWRREQ	0x1
>> 
>> Minor nit: maybe this should be called MAX77802_OFF_PWRREQ (without the OPMODE)?
>> Since afaiu from a conceptual pov the regulators only supports two modes: normal
>> and low power mode.
>> 
>> If a regulator is disabled or put in low power mode by PWRREQ on suspend, then
>> is not really an operating mode (the regulator output will still be normal until
>> suspend) but an enable pin to switch a regulator mode automatically by the SoC.
> 
> No problem. This is just a define for value used in register. However
> OPMODE is used in other places in that driver:
> #define MAX77686_OPMODE_SHIFT   6
> #define MAX77686_OPMODE_BUCK234_SHIFT   4
> #define MAX77686_OPMODE_MASK    0x3
>
> So this would be a little inconsistent...

Indeed, although I think there is a difference between talking about the OPMODE
field of the regulators control register (which the shift and mask refer to)
and the semantics of the value that is written (whether is an mode or an enable
pin).

But yeah, I agree the Maxim documentation is confusing and confused me too
before Mark explained to me that only two operating modes exist for this device.

> 
>> 
>> > +/*
>> > + * For some regulators this means:
>> > + *  - forcing low power mode.
>> > + *  - low power mode controlled by PWRREQ.
>> > + */
>> > +#define MAX77686_OPMODE_LOWPOWER	0x2
>> 
>> Can you also add a #define MAX77686_LP_PWRREQ 0x2 and use each one when
>> appropriate? That will better document when 0x2 means low power by PWRREQ
>> and when it means change regulator mode to low power.
> 
> Actually I made mistake in that comment. The 0x2 means force low power
> mode only for buck1-4... but there is no set_suspend_mode for these
> bucks. So this #define has only one semantic value.
> 
>> Also, are you sure that forcing low power mode is 0x2 and not 0x1?
> 
> You're right, for other LDOs, low power mode may be forced with 0x1. For
> such regulators the max77686_set_suspend_mode() is used which does not
> set value 0x1. This means that each define has only one semantic
> meaning.
> 
> I'll re-spin and fix the documentation to reflect both device
> capabilities and how the driver currently works.
> 
> Thanks for pointing this.
> 

You are welcome.

Best regards,
Javier 
