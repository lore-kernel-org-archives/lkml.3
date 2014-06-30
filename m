Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaF3Tec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:34:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52359 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaF3Tea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:34:30 -0400
Message-ID: <53B1BBA8.5090507@ti.com>
Date: Mon, 30 Jun 2014 14:34:00 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Tony Lindgren <tony@atomide.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/6] mailbox/omap: add support for parsing dt devices
References: <1403660878-56350-1-git-send-email-s-anna@ti.com> <1403660878-56350-3-git-send-email-s-anna@ti.com> <20140628170709.GB23634@xo-6d-61-c0.localdomain> <53B18999.2020506@ti.com> <20140630185942.GA5410@amd.pavel.ucw.cz>
In-Reply-To: <20140630185942.GA5410@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>
>>>> The non-DT support has to be maintained for now to not break
>>>> OMAP3 legacy boot, and the legacy-style code will be cleaned
>>>> up once OMAP3 is also converted to DT-boot only.
>>>
>>>> @@ -587,24 +606,157 @@ static int omap_mbox_unregister(struct omap_mbox_device *mdev)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static const struct omap_mbox_device_data omap2_data = {
>>>> +	.num_users	= 4,
>>>> +	.num_fifos	= 6,
>>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
>>>> +};
>>>> +
>>>> +static const struct omap_mbox_device_data omap3_data = {
>>>> +	.num_users	= 2,
>>>> +	.num_fifos	= 2,
>>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
>>>> +};
>>>> +
>>>> +static const struct omap_mbox_device_data am335x_data = {
>>>> +	.num_users	= 4,
>>>> +	.num_fifos	= 8,
>>>> +	.intr_type	= MBOX_INTR_CFG_TYPE2,
>>>> +};
>>>
>>> So you use compatible strings to look up 3 integers. Would it be better to have
>>> num_users/num_fifos/intr_type directly in the device tree? That should be cleaner
>>> and more flexible...
>>>
>>> If you do that, would it be possible to have share compatible string?
>>
>> Yeah, I have actually encoded the .num_users and .num_fifos in DT in the
>> previous version [1] with shared compatible strings, but dropped those
>> properties in favour of adding minimal custom properties to DT based on
>> some offline IRC comments. I have no objections either way, but there is
>> really nothing to be gained from minimizing compatible strings.
> 
> Actually, I'd guess best solution would be to do both: have it encoded
> in device tree _and_ have separate compatible string for each version
> (in case there are other differences). You'd still get rid of the
> table...

Do note that the .intr_type has to with the register layout rather than
a physical property (mainly to distinguish the pre-OMAP4 IP register
layout), so I am not convinced that belongs to DT. This is the reason
why I didn't represent it in DT even in the previous version. The other
two are HW IP design parameters, so in general putting them in DT isn't
completely a bad idea, but I will wait to see if there are any further
comments on this from Tony or DT maintainers before I make changes.

regards
Suman
