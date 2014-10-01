Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaJASLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:11:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:45295 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaJASLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:11:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,633,1406617200"; 
   d="scan'208";a="582042325"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Wed, 01 Oct 2014 11:11:46 -0700
Subject: Re: [PATCH v3 10/15] leds: leds-gpio: Add ACPI probing support
From: Darren Hart <dvhart@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-acpi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>
Message-ID: <D05191AB.AB380%dvhart@linux.intel.com>
Thread-Topic: [PATCH v3 10/15] leds: leds-gpio: Add ACPI probing support
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1852462.V1jlbi8OPt@vostro.rjw.lan>
 <4835699.XutTNxriDg@vostro.rjw.lan>
 <2780318.hxubhI9Rvq@wuerfel>
 <20141001163025.GE23115@dtor-glaptop>
In-Reply-To: <20141001163025.GE23115@dtor-glaptop>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/14, 9:30, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

>On Wed, Oct 01, 2014 at 10:13:04AM +0200, Arnd Bergmann wrote:
>> On Wednesday 01 October 2014 04:17:02 Rafael J. Wysocki wrote:
>> > Index: linux-pm/drivers/leds/leds-gpio.c
>> > ===================================================================
>> > --- linux-pm.orig/drivers/leds/leds-gpio.c
>> > +++ linux-pm/drivers/leds/leds-gpio.c
>> > @@ -231,6 +231,13 @@ static const struct of_device_id of_gpio
>> >  
>> >  MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
>> >  
>> > +static const struct acpi_device_id acpi_gpio_leds_match[] = {
>> > +       { "PRP0001" }, /* Device Tree shoehorned into ACPI */
>> > +       {},
>> > +};
>> > +
>> > +MODULE_DEVICE_TABLE(acpi, acpi_gpio_leds_match);
>> > +
>> >  static int gpio_led_probe(struct platform_device *pdev)
>> >  {
>> >         struct gpio_led_platform_data *pdata =
>>dev_get_platdata(&pdev->dev);
>> > @@ -286,6 +293,7 @@ static struct platform_driver gpio_led_d
>> >                 .name   = "leds-gpio",
>> >                 .owner  = THIS_MODULE,
>> >                 .of_match_table = of_gpio_leds_match,
>> > +               .acpi_match_table = acpi_gpio_leds_match,
>> >         },
>> >  };
>> 
>> Is this something you'd have to do in every driver you want to support
>> _PRP based probing? For the ".acpi_match_table =" reference, I think
>> you could actually provide a generic acpi_device_id table exported from
>> core code that you refer to, so each driver just does
>> 
>> 	.acpi_match_table = acpi_match_by_of_compatible,
>
>No, I think in absence of drv->acpi_match_table ACPI core should just go
>and
>use drv->of_match_table to do the matching and be done with it.

But then you will match drivers that have of-only support that don't know
anything about ACPI and haven't been updated to use the new API. Worse,
some of those drivers will assume of node structs and such and potentially
panic. Unless I'm sorry mistaken here....

-- 
Darren Hart
Intel Open Source Technology Center



