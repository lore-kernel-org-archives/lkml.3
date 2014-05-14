Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaENT1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:27:31 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:48514 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaENT1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <5373C2EB.8020806@infradead.org>
References: <1400094649-11193-1-git-send-email-f.fainelli@gmail.com>
 <1400094649-11193-3-git-send-email-f.fainelli@gmail.com> <5373C2EB.8020806@infradead.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 14 May 2014 12:26:49 -0700
Message-ID: <CAGVrzcZK0P8b_8B9wgfh180KWE1+1KN-dypoj8v4VGuZ8R-hew@mail.gmail.com>
Subject: Re: [PATCH 1/3] bus: add Broadcom GISB bus arbiter timeout/error handler
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Huang Shijie <b32955@freescale.com>,
        "open list:DOCUMENTATION <linux-doc@vger.kernel.org>, open list:OPEN
	FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-14 12:24 GMT-07:00 Randy Dunlap <rdunlap@infradead.org>:
> On 05/14/2014 12:10 PM, Florian Fainelli wrote:
>> This patch adds support for the Broadcom GISB arbiter bus timeout/error
>> handler. GISB is a proprietary bus used by Broadcom Set Top Box
>> System-on-a-chip devices (BCM7xxx) which allows multiple masters and
>> clients to be interfaced with each other.
>>
>> The bus arbiter offers support for generating two interrupts towards the
>> host CPU, thus allowing us to "catch" clock gated masters, or masters
>> being volontarily blocked for powersaving purposes, or do general system
>> troubleshooting.
>>
>> We also register a hook with the ARM fault exception handling to allow
>> printing a more informative message than "imprecise external abort at
>> 0x00000000" for instance.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/bus/Kconfig        |  11 +-
>>  drivers/bus/Makefile       |   1 +
>>  drivers/bus/brcmstb_gisb.c | 289 +++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 300 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/bus/brcmstb_gisb.c
>>
>> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
>> index 552373c4e362..985db51c0b11 100644
>> --- a/drivers/bus/Kconfig
>> +++ b/drivers/bus/Kconfig
>> @@ -40,5 +40,14 @@ config ARM_CCI
>>       depends on ARM
>>       help
>>         Driver supporting the CCI cache coherent interconnect for ARM
>> -       platforms.
>> +       kplatforms.
>
> Is that a typo?  if not, what are kplatforms?

This is indeed a typo.
-- 
Florian
