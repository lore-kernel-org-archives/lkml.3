Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3E0Q2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:28:04 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:32860 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab3E0Q2D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:28:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1369672081!11178467!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>,
        "mcrapet@gmail.com" <mcrapet@gmail.com>
Date: Mon, 27 May 2013 11:27:01 -0500
Subject: RE: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion to
 PWM framework
Thread-Topic: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion
 to PWM framework
Thread-Index: Ac5a7bBUg1AJ7Ay6RTev1TYDm2X5RQACFAeM
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA666D43D@AUSP01VMBX24.collaborationhost.net>
References: <201305241619.52328.hartleys@visionengravers.com>,<201305271720.08146.arnd@arndb.de>
In-Reply-To: <201305271720.08146.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 27, 2013 8:20 AM, Arnd Bergmann wrote:
> On Saturday 25 May 2013, H Hartley Sweeten wrote:
>> This driver needs to be converted to the new PWM framework.
>>
>> Before converting it clean up all the cruft,
>>
>> H Hartley Sweeten (14):
>>   misc/ep93xx_pwm: use managed device resources
>>   misc/ep93xx_pwm: use {read,write}* instead of __raw_* versions for io
>>   misc/ep93xx_pwm: remove ep93xx_pwm_{write,read}l() inline functions
>>   misc/ep93xx_pwm: remove ep93xx_pwm_write_tc() inline function
>>   misc/ep93xx_pwm: remove ep93xx_pwm_write_dc() inline function
>>   misc/ep93xx_pwm: remove ep93xx_pwm_enable() inline function
>>   misc/ep93xx_pwm: remove ep93xx_pwm_disable() inline function
>>   misc/ep93xx_pwm: remove ep93xx_pwm_invert() inline function
>>   misc/ep93xx_pwm: remove ep93xx_pwm_normal() inline function
>>   misc/ep93xx_pwm: remove ep93xx_pwm_read_tc() inline function
>>   misc/ep93xx_pwm: remove ep93xx_pwm_is_enabled() inline function
>>   misc/ep93xx_pwm: remove ep93xx_pwm_is_inverted() inline function
>>   misc/ep93xx_pwm: use module_platform_driver()
>>   misc/ep93xx_pwm: use kstrtol instead of strict_strtol
>
> Whole series:
>
> Acked-by: Arnd Bergmann arnd@arndb.de

Arnd,

Ryan Mallon has also provided a Reviewed-by for this series.

Will you be the one that merges this? I would like it to be in linux-next
before I convert it to the PWM framework.

Also, I have a question about the conversion.

If I strip the sysfs support out of this driver the conversion is quite simple.
But, my use for this driver requires user space control of the PWM.

Should I:
1) convert the driver to the PWM framework and leave the sysfs stuff in it
2) work out a generic sysfs support for the PWM framework and then
    convert the driver
3) other...

I've been looking at 2) by doing something like how gpiolib does it. Do
you think that would be acceptable?

Thanks,
Hartley