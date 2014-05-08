Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaEHRWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:22:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40183 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751856AbaEHRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:22:45 -0400
Date: Thu, 8 May 2014 19:22:43 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Josh Wu <josh.wu@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 2/2] iio:adc: at91 requires the input subsystem
Message-ID: <20140508172243.GC6095@piout.net>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-13-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-13-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/05/2014 at 16:56:24 +0200, Arnd Bergmann wrote :
> Building the at91 adc driver with CONFIG_INPUT disabled results in this
> build error:
> 
> ERROR: "input_event" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_unregister_device" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_free_device" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_register_device" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_set_abs_params" [drivers/iio/adc/at91_adc.ko] undefined!
> ERROR: "input_allocate_device" [drivers/iio/adc/at91_adc.ko] undefined!
> 
> To make sure we can build random configurations, this turns on CONFIG_INPUT
> whenever CONFIG_AT91_ADC is enabled.
> 

I'm wondering wether we should make part of the driver compile only if
CONFIG_INPUT is defined. Maybe some user will want to use the ADC and
not have any input on their board.

What do you think ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
