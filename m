Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaEHRcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:32:00 -0400
Received: from smtp-out-032.synserver.de ([212.40.185.32]:1235 "EHLO
	smtp-out-016.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753160AbaEHRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:31:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10200
Message-ID: <536BBF78.7080100@metafoo.de>
Date: Thu, 08 May 2014 19:31:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Josh Wu <josh.wu@atmel.com>, Jonathan Cameron <jic23@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 2/2] iio:adc: at91 requires the input subsystem
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-13-git-send-email-arnd@arndb.de> <20140508172243.GC6095@piout.net>
In-Reply-To: <20140508172243.GC6095@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 07:22 PM, Alexandre Belloni wrote:
> Hi,
>
> On 08/05/2014 at 16:56:24 +0200, Arnd Bergmann wrote :
>> Building the at91 adc driver with CONFIG_INPUT disabled results in this
>> build error:
>>
>> ERROR: "input_event" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_unregister_device" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_free_device" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_register_device" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_set_abs_params" [drivers/iio/adc/at91_adc.ko] undefined!
>> ERROR: "input_allocate_device" [drivers/iio/adc/at91_adc.ko] undefined!
>>
>> To make sure we can build random configurations, this turns on CONFIG_INPUT
>> whenever CONFIG_AT91_ADC is enabled.
>>
>
> I'm wondering wether we should make part of the driver compile only if
> CONFIG_INPUT is defined. Maybe some user will want to use the ADC and
> not have any input on their board.
>
> What do you think ?
>

This typically just leads to more build errors. E.g. if INPUT is defined as 
a module, but AT91_ADC is build in. I think it is very rare to see a 
configuration without INPUT set, other then a randconfig.

- Lars
