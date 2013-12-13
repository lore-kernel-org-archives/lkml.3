Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3LMRhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:37:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36152 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab3LMRgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:36:49 -0500
Message-ID: <52AB45AF.8040902@ti.com>
Date: Fri, 13 Dec 2013 11:36:47 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Roger Quadros <rogerq@ti.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: twl4030: fix regression for twl gpio outputs for
 led pins
References: <1386953222-26396-1-git-send-email-nm@ti.com> <20131213172810.GE28184@atomide.com>
In-Reply-To: <20131213172810.GE28184@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 11:28 AM, Tony Lindgren wrote:
> * Nishanth Menon <nm@ti.com> [131213 08:48]:
>> Commit 0b2aa8b (gpio: twl4030: Fix regression for twl gpio output)
>> introduces yet another regression by ignoring the fact that we use twl
>> gpio even for LED. For example, leda (offset 18) is used for USB port2
>> power on beagleboard-xm.
>>
>> The original logic was supposed to setup the TWL4030 GPIO direction
>> if the offset was < TWL4030_GPIO_MAX, and anything greater used
>> twl4030_led_set_value as part of twl_set to setup the LED pin. However,
>> with the commit mentioned above, LEDa pin request will result in fail
>> as the GPIO number for LEDa is equal to TWL4030_GPIO_MAX and USB fails
>> to function on beagleboard-xm. This is reported in the log as:
>> hsusb2_vbus: Failed to request enable GPIO510: -22
>>
>> To fix this, we should handle the fail case of
>> twl4030_set_gpio_direction independent of the offset < TWL4030_GPIO_MAX
>> check.
> 
> Heh again :) Linus has already queued a similar fix, see
> "[PATCH v2 1/1] gpio: twl4030: Fix regression for twl gpio LED output".
> 

Alrite, I admit it, I need a vacation ;).. Sigh..
http://marc.info/?l=linux-gpio&w=2&r=1&s=twl4030&q=t is not good
enough :(..


-- 
Regards,
Nishanth Menon
