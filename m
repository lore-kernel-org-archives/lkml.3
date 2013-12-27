Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3L0GaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:30:23 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:60833 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3L0GaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:30:21 -0500
MIME-Version: 1.0
In-Reply-To: <20131227051843.GA840@kroah.com>
References: <1388120848-15879-1-git-send-email-tushar.behera@linaro.org>
	<20131227051843.GA840@kroah.com>
Date: Fri, 27 Dec 2013 12:00:20 +0530
Message-ID: <CAHbNUh27ZZ5UxuLMPvv6weNOSG4XKV9ZRrmTB9F0RvgQxufGDQ@mail.gmail.com>
Subject: Re: [PATCH] serial: samsung: Remove hard-coded major/minor numbers
From: Tushar Behera <tushar.behera@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-serial <linux-serial@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, jslaby <jslaby@suse.cz>,
        Patch Tracking <patches@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 December 2013 10:48, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Dec 27, 2013 at 10:37:28AM +0530, Tushar Behera wrote:
>> The hard-coded values clash with the values set for amba-pl011 serial
>> driver. Because of this there is no serial output on Samsung boards
>> if amba-pl011 is enabled alongwith samsung-serial driver.
>>
>> Remove the hardcoded values and let the framework decide on
>> appropriate major/minor number. This is required for multi-platform
>> development work on Exynos platform.
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  drivers/tty/serial/samsung.c |    4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
>> index c1af04d..9c20543 100644
>> --- a/drivers/tty/serial/samsung.c
>> +++ b/drivers/tty/serial/samsung.c
>> @@ -56,8 +56,6 @@
>>  /* UART name and device definitions */
>>
>>  #define S3C24XX_SERIAL_NAME  "ttySAC"
>> -#define S3C24XX_SERIAL_MAJOR 204
>> -#define S3C24XX_SERIAL_MINOR 64
>>
>>  /* macros to change one thing to another */
>>
>> @@ -951,8 +949,6 @@ static struct uart_driver s3c24xx_uart_drv = {
>>       .nr             = CONFIG_SERIAL_SAMSUNG_UARTS,
>>       .cons           = S3C24XX_SERIAL_CONSOLE,
>>       .dev_name       = S3C24XX_SERIAL_NAME,
>> -     .major          = S3C24XX_SERIAL_MAJOR,
>> -     .minor          = S3C24XX_SERIAL_MINOR,
>
> Doesn't this break existing systems and configurations that are
> expecting 204:64 as the location of this serial port?
>

I tested this on Exynos4210-Origen, Exynos5250-Arndale board, it works
fine there. I haven't tested on any older boards.

> Why change this one and not the amba-pl011 driver?
>

I could only test this driver, so thought of changing this rather than
modifying amba-pl011 driver. I don't have any other reason.

> greg k-h


Thanks for reviewing.
-- 
Tushar Behera
