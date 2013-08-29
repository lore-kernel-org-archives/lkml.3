Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab3H2Uc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:32:57 -0400
Received: from momout1-smtp.messagingengine.com ([66.111.4.229]:41472 "EHLO
	momout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755860Ab3H2Ucy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:32:54 -0400
X-Greylist: delayed 702 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Aug 2013 16:32:53 EDT
X-Sasl-enc: oxRAGksggWrimBslwQ1oBxyJ/ee5TLBebTQlwWXnmijs 1377807662
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Linus Walleij" <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ian.campbell@citrix.com>
Subject: Re: [PATCH V5] gpio: New driver for LSI ZEVIO SoCs
References: <1377541133-7427-1-git-send-email-fabian@ritter-vogt.de>
 <CACRpkdbnvnCiJ1apWA4gq03QH-vhmKae_3yYjYxEqGzYsWjaqg@mail.gmail.com>
Date: Thu, 29 Aug 2013 22:28:56 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Fabian Vogt" <vogtinator@myopera.com>
Message-ID: <op.w2lhuicjfdrgmf@fabians-laptop.fritz.box>
In-Reply-To: <CACRpkdbnvnCiJ1apWA4gq03QH-vhmKae_3yYjYxEqGzYsWjaqg@mail.gmail.com>
User-Agent: Opera Mail/12.16 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 08/26/2013 12:18 PM, Fabian Vogt wrote:
>> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
>> It has been successfully tested on a TI nspire CX calculator.

> What changed in v5 (or indeed any other versions?)

> Repeating what Stephen said, can you please provide a changelog?
> I need an overview of what changed over time.
>
> Yours,
> Linus Walleij
Oh, ok.

V2: Mail client had bug I didn't notice, resend with git send-email
V3: Noticed that git send-email did not invoke cleanpatch
V4: Changed uint*_t to u*, renamed "sticky IRQ" to "level IRQ"
V5: Removed #ngpios
V6 (coming): Mark Rutlands suggestions (Don't free devm allocated memory,  
readable macros) and a description of the changes

>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt  
>> b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>
>> +Zevio GPIO controller
>> +
>> +Required properties:
>> +- compatible = "lsi,zevio-gpio"
>> +- reg = <BASEADDR SIZE>
>Perhaps this should say:
>reg: Contains a single register specifier for the GPIO module's  
> registers.

reg = Register specifier for the location and size of the GPIO  
controller's registers.

>> +- #gpio-cells = <2>
>This should describe what those cells are. For example perhaps:
>
> #gpio-cells. Must be 2. The first cell is the GPIO number. The second
>  cell is used to specify optional parameters:
>  - bit 0 specifies polarity (0 for normal, 1 for inverted)
"Must be 2. The second cell is ... optional"?
