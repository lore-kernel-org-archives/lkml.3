Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762731Ab3IDOYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:24:52 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52421 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762603Ab3IDOYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:24:51 -0400
Date: Wed, 4 Sep 2013 15:24:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree@vger.kernel.org"@arm.com
Subject: Re: [PATCH] Documentation: dt: i2c: Add LPS001WP to the Trivial
 Devices list
Message-ID: <20130904142422.GM18206@e106331-lin.cambridge.arm.com>
References: <1378302655-13258-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378302655-13258-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Cheers for producing a binding.

On Wed, Sep 04, 2013 at 02:50:55PM +0100, Lee Jones wrote:
> LPS001WP is a Pressure and Temperature sensor.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/i2c/trivial-devices.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> index ad6a738..6038807e6 100644
> --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> @@ -57,6 +57,7 @@ st-micro,24c256		i2c serial eeprom  (24cxx)
>  stm,m41t00		Serial Access TIMEKEEPER
>  stm,m41t62		Serial real-time clock (RTC) with alarm
>  stm,m41t80		M41T80 - SERIAL ACCESS RTC WITH ALARMS
> +stm,lps001wp		Pressure and Temperature sensor

As I hinted at in the other thread [1], I don't think this can be
documented as a trivial binding -- the driver expects a couple of
regulators which should be described in the binding (or the driver
shouldn't be using them...).

Also, in the other thread the "st," prefix was used [2], while "stm," is
listed at the prefix in the binding. As far as I can see, "st," should
be used, as it's in vendor-prefixes and "stm," is not.

I'm happy to cook up a patch adding deprecation notes and corrected
strings for the existing incorrect "stm," bindings.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/196561.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/196558.html

Thanks,
Mark.

>  taos,tsl2550		Ambient Light Sensor with SMBUS/Two Wire Serial Interface
>  ti,tsc2003		I2C Touch-Screen Controller
>  ti,tmp102		Low Power Digital Temperature Sensor with SMBUS/Two Wire Serial Interface
> -- 
> 1.8.1.2
> 
> 
