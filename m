Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3KYX2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:28:33 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:54189 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3KYX2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <5293DBEF.3010401@roeck-us.net>
References: <1385420137-32725-1-git-send-email-dianders@chromium.org>
	<5293DBEF.3010401@roeck-us.net>
Date: Mon, 25 Nov 2013 15:28:29 -0800
X-Google-Sender-Auth: tzEoj_Z1zRl3JSM7z9-i0TrXLz4
Message-ID: <CAD=FV=WijF-ZyST8p13Rog1VGSx+c-2MES+FpxbSGzd16rAZoA@mail.gmail.com>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Only register for cpufreq on CPU_FREQ_S3C24XX
From: Doug Anderson <dianders@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,

On Mon, Nov 25, 2013 at 3:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 11/25/2013 02:55 PM, Doug Anderson wrote:
>>
>> On modern SoCs the watchdog timer is parented on a clock that doesn't
>> change every time we have a cpufreq change.  That means we don't need
>> to constantly adjust the watchdog timer, so avoid registering for and
>> dealing with cpufreq transitions unless we've actually got
>> CPU_FREQ_S3C24XX defined.
>>
>> Note that this is more than just an optimization.  The s3c2410
>> watchdog driver actually pats the watchdog on every CPU frequency
>> change.  On modern systems these happen many times per second (even in
>> a system where "nothing" is happening).  That effectively makes any
>> userspace watchdog program useless (the watchdog is constantly patted
>> by the kernel).  If we need CPU_FREQ_S3C24XX defined on a
>> multiplatform kernel we'll need to make sure that kernel supports
>> common clock and change this to user common clock framework.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>   drivers/watchdog/s3c2410_wdt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/watchdog/s3c2410_wdt.c
>> b/drivers/watchdog/s3c2410_wdt.c
>> index 7d8fd04..4980f84 100644
>> --- a/drivers/watchdog/s3c2410_wdt.c
>> +++ b/drivers/watchdog/s3c2410_wdt.c
>> @@ -264,7 +264,7 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void
>> *param)
>>         return IRQ_HANDLED;
>>   }
>>
>> -#ifdef CONFIG_CPU_FREQ
>> +#ifdef CONFIG_CPU_FREQ_S3C24XX
>>
> Where is the CPU_FREQ_S3C24XX configuration option defined ? I don't see it
> in the current upstream kernel, so it appears that this depends on some
> out-of-tree changes.

Whoops!  I guess I just trusted another patch and didn't dig.  I was
basing this on https://patchwork.kernel.org/patch/3023421/

Ah, I see that Tomasz just found the answer.  I'll update my patch.

-Doug
