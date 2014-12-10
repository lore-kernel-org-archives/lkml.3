Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaLJBM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:12:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:9756 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaLJBM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:12:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="496365080"
Message-ID: <54879E08.7030108@intel.com>
Date: Wed, 10 Dec 2014 02:12:40 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>, Fabio Estevam <fabio.estevam@freescale.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Fabio Estevam <festevam@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: leds-gpio: Fix the "default-state" property check
References: <1418142714-29794-1-git-send-email-fabio.estevam@freescale.com> <CAK5ve-KHd86BxLhk=JC6vspgE7E_W3A3ArrjHsGp41_iuke7fA@mail.gmail.com>
In-Reply-To: <CAK5ve-KHd86BxLhk=JC6vspgE7E_W3A3ArrjHsGp41_iuke7fA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/2014 8:13 PM, Bryan Wu wrote:
> On Tue, Dec 9, 2014 at 8:31 AM, Fabio Estevam
> <fabio.estevam@freescale.com> wrote:
>> Commit a43f2cbbb009f9 ("leds: leds-gpio: Make use of device property API")
>> caused a regression by reading the incorrect string for the "default-state"
>> property.
>>
>> Fix the property string check to restore the original behaviour.
>>
>> Fixes: a43f2cbbb009 (leds: leds-gpio: Make use of device property API)
> Thanks, please take my Ack
> Acked-by: Bryan Wu <cooloney@gmail.com>
>
> I think Rafael will take this fix with other patches through his tree.

Yes, I will, thanks!

And sorry for the breakage ...

>
>> Reported-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>> ---
>>   drivers/leds/leds-gpio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
>> index 8a8ba11..7ea1ea42 100644
>> --- a/drivers/leds/leds-gpio.c
>> +++ b/drivers/leds/leds-gpio.c
>> @@ -203,7 +203,7 @@ static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
>>                  fwnode_property_read_string(child, "linux,default-trigger",
>>                                              &led.default_trigger);
>>
>> -               if (!fwnode_property_read_string(child, "linux,default_state",
>> +               if (!fwnode_property_read_string(child, "default-state",
>>                                                   &state)) {
>>                          if (!strcmp(state, "keep"))
>>                                  led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
>> --
>> 1.9.1
>>

