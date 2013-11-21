Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3KUJsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:48:42 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36894 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3KUJsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:48:38 -0500
MIME-Version: 1.0
In-Reply-To: <528CDFFB.1020601@overkiz.com>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
	<1377687995-10758-1-git-send-email-b.brezillon@overkiz.com>
	<20131120145926.GE14627@ns203013.ovh.net>
	<528CDFFB.1020601@overkiz.com>
Date: Thu, 21 Nov 2013 10:48:37 +0100
Message-ID: <CACRpkdboBg4YOnMNiar0DDBVnoky=zNky+Pzyp1=P_POtH15qQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] ARM: at91/dt: add mmc0 slot0 support to at91rm9200ek board
From: Linus Walleij <linus.walleij@linaro.org>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 5:14 PM, boris brezillon
<b.brezillon@overkiz.com> wrote:
> On 20/11/2013 15:59, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On 13:06 Wed 28 Aug     , Boris BREZILLON wrote:

>>> mmc0_slot0_switch-0 {
>>> +                                               atmel,pins =
>>> +                                                       <AT91_PIOB 22
>>> AT91_PERIPH_GPIO (AT91_PINCTRL_OUTPUT | AT91_PINCTRL_OUTPUT_VAL(1))>;
>>> +                                       };
>>
>> nack this is a regulator the pinctrl API is not done for gpio default
>> value
>
> I know this can be represented as a regulator, but looking at the datasheet,
> this looks more like a switch than a regulator.

No matter whether it's a switch or a GPIO regulator it seems we
are in violent agreement that it should not be controlled by the
pin control states at least.

Start with making it a GPIO then you can figure out whether
a GPIO regulator or drivers/extcon/extcon-gpio.c should be
used.

Yours,
Linus Walleij
