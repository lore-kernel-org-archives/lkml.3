Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaCPTQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:16:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54602 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752603AbaCPTQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:16:42 -0400
Date: Sun, 16 Mar 2014 20:16:39 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 04/15] iio: adc: at91_adc: Add support for touchscreens
 without TSMR
Message-ID: <20140316191639.GJ3106@piout.net>
References: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1394040940-18246-5-git-send-email-alexandre.belloni@free-electrons.com>
 <5325EA96.9000907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5325EA96.9000907@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/2014 at 18:16:54 +0000, Jonathan Cameron wrote :
> On 05/03/14 17:35, Alexandre Belloni wrote:
> >Old ADCs, as present on the sam9rl and the sam9g45 don't have a TSMR register
> >and the touchscreen support should be handled differently.
> >
> >Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> One comment inline about handling of devices where the platform data doesn't
> include the touchscreen type.  I'd expect zero to be the current default
> rather than NONE...
> >diff --git a/include/linux/platform_data/at91_adc.h b/include/linux/platform_data/at91_adc.h
> >index fcf73879dbfe..7819fc787731 100644
> >--- a/include/linux/platform_data/at91_adc.h
> >+++ b/include/linux/platform_data/at91_adc.h
> >@@ -7,6 +7,12 @@
> >  #ifndef _AT91_ADC_H_
> >  #define _AT91_ADC_H_
> >
> >+enum atmel_adc_ts_type {
> This means that the default for existing touch screens (where the platform
> data won't include setting this value) will be none.  Is that correct?
> >+	ATMEL_ADC_TOUCHSCREEN_NONE = 0,
> >+	ATMEL_ADC_TOUCHSCREEN_4WIRE = 4,
> >+	ATMEL_ADC_TOUCHSCREEN_5WIRE = 5,
> >+};
> >+

This is actually just a snippet that I moved from at91_adc.c to
at91_adc.h. I followed the current behavior.  Until now, using the
touchscreen was only supported through device tree and touchscreen
handling was not activated unless the atmel,adc-ts-wires property is
present.  I guess this is the sane way to go because when you use the
touchscreen, you lose the triggers.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
