Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3A1KTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:19:30 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:49788 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3A1KTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:19:24 -0500
MIME-Version: 1.0
In-Reply-To: <51063791.9090606@atmel.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de> <1359153858-31992-11-git-send-email-arnd@arndb.de>
 <51063791.9090606@atmel.com>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Mon, 28 Jan 2013 11:19:03 +0100
Message-ID: <CAHkwnC-emr-mx_s7ka3_M1dy-u8RaA37XzxD2rTNarYMXG4y5Q@mail.gmail.com>
Subject: Re: [PATCH 10/19] watchdog: at91sam9: at91_wdt_dt_ids cannot be __init
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 9:32 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> On 01/25/2013 11:44 PM, Arnd Bergmann :
>> The device IDs are referenced by the driver and potentially
>> used beyond the init time, as kbuild correctly warns
>> about. Remove the __initconst annotation.
>>
>> Without this patch, building at91_dt_defconfig results in:
>>
>> WARNING: drivers/watchdog/built-in.o(.data+0x28): Section mismatch in reference from the variable at91wdt_driver to the (unknown reference) .init.rodata:(unknown)
>> The variable at91wdt_driver references
>> the (unknown reference) __initconst (unknown)
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Wim Van Sebroeck <wim@iguana.be>
>> Cc: linux-watchdog@vger.kernel.org
>> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
> Thanks,
>
>> Cc: Fabio Porcedda <fabio.porcedda@gmail.com>

Tested-by: Fabio Porcedda <fabio.porcedda@gmail.com>

Thanks.

>> ---
>>  drivers/watchdog/at91sam9_wdt.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
>> index dc42e44..6dad954 100644
>> --- a/drivers/watchdog/at91sam9_wdt.c
>> +++ b/drivers/watchdog/at91sam9_wdt.c
>> @@ -304,7 +304,7 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
>>  }
>>
>>  #if defined(CONFIG_OF)
>> -static const struct of_device_id at91_wdt_dt_ids[] __initconst = {
>> +static const struct of_device_id at91_wdt_dt_ids[] = {
>>       { .compatible = "atmel,at91sam9260-wdt" },
>>       { /* sentinel */ }
>>  };
>>
>
>
> --
> Nicolas Ferre



--
Fabio Porcedda
