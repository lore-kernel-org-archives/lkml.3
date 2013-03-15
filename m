Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3CORoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:44:09 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.207]:14030 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867Ab3CORoI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:44:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1363369393!20410214!73
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>, Fabio Porcedda <fabio.porcedda@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 15 Mar 2013 12:43:48 -0500
Subject: RE: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Thread-Topic: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Thread-Index: Ac4gvAJZqqd2Y1i7ScKBxQfXbMv1lQA53iFQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020980106B9E@AUSP01VMBX24.collaborationhost.net>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <1363266691-15757-12-git-send-email-fabio.porcedda@gmail.com>
 <201303141358.05616.arnd@arndb.de>
In-Reply-To: <201303141358.05616.arnd@arndb.de>
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

On Thursday, March 14, 2013 6:58 AM, Arnd Bergmann wrote:
> On Thursday 14 March 2013, Fabio Porcedda wrote:
>> This patch converts the drivers to use the
>> module_platform_driver_probe() macro which makes the code smaller and
>> a bit simpler.
>> 
>> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/misc/atmel_pwm.c  | 12 +-----------
>>  drivers/misc/ep93xx_pwm.c | 13 +------------
>>  2 files changed, 2 insertions(+), 23 deletions(-)
>
> The patch itself seems fine, but there are two issues around it:
>
> * The PWM drivers should really get moved to drivers/pwm and converted to the new
>   PWM subsystem. I don't know if Hartley or Hans-Christian have plans to do
>   that already.

Arnd,

Ill look at converting the ep93xx pwm driver to the PWM subsystem. The only issue is
the current driver exposes a sysfs interface that I think is not available in that subsystem.

>* Regarding the use of module_platform_driver_probe, I'm a little worried about
>  the interactions with deferred probing. I don't think there are any regressions,
>  but we should probably make people aware that one cannot return -EPROBE_DEFER
>  from a platform_driver_probe function.

The ep93xx pwm driver does not need to use platform_driver_probe(). It can be changed
to use module_platform_driver() by just moving the .probe to the platform_driver. This
driver was added before module_platform_driver() was available and I used the
platform_driver_probe() thinking it would save a couple lines of code.

I'll change this in a bit. Right now I'm trying to work out why kernel 3.8 is not booting
on the ep93xx. I had 3.6.6 on my development board and 3.7 works fine but 3.8 hangs
without uncompressing the kernel.

Regards,
Hartley



