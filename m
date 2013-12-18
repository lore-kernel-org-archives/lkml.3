Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3LRCCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:02:16 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:3399 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3LRCCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:02:14 -0500
X-IronPort-AV: E=Sophos;i="4.95,504,1384329600"; 
   d="scan'208";a="3617848"
Message-ID: <52B1021F.2010708@broadcom.com>
Date: Tue, 17 Dec 2013 18:02:07 -0800
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbn?= =?ISO-8859-1?Q?er?= 
	<heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/6] pinctrl: Add pinctrl binding for Broadcom Capri
 SoCs
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>	<1386787041-6035-1-git-send-email-syin@broadcom.com>	<1386787041-6035-5-git-send-email-syin@broadcom.com>	<CACRpkdY7s+eUFkg0AsaN5B9-1y_mTJ29Y-D9CkRG2GQ3JshP+w@mail.gmail.com>	<52ABB150.1030702@broadcom.com> <CACRpkdZ5Cxii48CsVJzEaBhvZOs8JCcR_hJV=RczhHbW4aqG-w@mail.gmail.com>
In-Reply-To: <CACRpkdZ5Cxii48CsVJzEaBhvZOs8JCcR_hJV=RczhHbW4aqG-w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-16 05:17 AM, Linus Walleij wrote:
> On Sat, Dec 14, 2013 at 2:16 AM, Sherman Yin <syin@broadcom.com> wrote:
>
>>>> +- bias-pull-up:                        Integer. Pull up strength in Ohm:
>>>> +                                       1: 1.2 kOhm
>>>> +                                       2: 1.8 kOhm
>>>> +                                       3: 720 Ohm
>>>> +                                       4: 2.7 kOhm
>>>> +                                       5: 831 Ohm
>>>> +                                       6: 1.08 kOhm
>>>> +                                       7: 568 Ohm
>>>
>>>
>>> Please do not use these custom enumerators 1 thru 7.
>>> Instead say that the argument is given in ohms, so for
>>> example:
>>>
>>> bias-pull-up = <12000>;
>>>
>>> Then translate this into the proper enumerator in your
>>> driver instead.
>>
>> Ok.  The 3 bits in this enumeration correspond to enabling the 3 pull up Rs
>> (1.2k, 1.8k, 2.7k) in parallel, so the enum kind of make sense. But sure I
>> can change it to actual ohms and will error out in the driver if specified
>> value is not one of the 7.
>
> Aha, that's how they do it :-)
>
> Please write this in a comment in the driver because it makes
> it a lot easier to understand what is going on, and e.g. how to
> fuzz an apropriate resistance.

Yes, I plan to explain where those odd numbers come from in this file.

> Can you tell me something about how such resistors are produced
> in silicon?

Sorry I'm not quite sure.  I only know a little bit of the circuitry 
down to the schematic level...

Regards,
Sherman
