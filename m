Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3C0CNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:13:09 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:33584 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3C0CNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130326152310.GA9153@roeck-us.net>
References: <1364281619-13208-1-git-send-email-hongbo.zhang@linaro.org>
	<1364281619-13208-6-git-send-email-hongbo.zhang@linaro.org>
	<20130326152310.GA9153@roeck-us.net>
Date: Wed, 27 Mar 2013 10:13:05 +0800
Message-ID: <CAJLyvQyghAvh4jw-DHmAsJ0EMHG0eZh8mtfXZTkzYjqpessPZw@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] hwmon: add ST-Ericsson ABX500 hwmon driver
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: khali@linux-fr.org, lm-sensors@lm-sensors.org, cbou@mail.ru,
        dwmw2@infradead.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 23:23, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, Mar 26, 2013 at 03:06:59PM +0800, Hongbo Zhang wrote:
>> Each of ST-Ericsson X500 chip set series consists of both ABX500 and DBX500
>> chips. This is ABX500 hwmon driver, where the abx500.c is a common layer for
>> all ABX500s, and the ab8500.c is specific for AB8500 chip. Under this designed
>> structure, other chip specific files can be added simply using the same common
>> layer abx500.c.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
>
> Looks good except ...
>
>> diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
>> index d9f1f25..05a1077 100644
>> --- a/drivers/power/ab8500_bmdata.c
>> +++ b/drivers/power/ab8500_bmdata.c
>> @@ -28,8 +28,10 @@ const struct abx500_res_to_temp ab8500_temp_tbl_a_thermistor[] = {
>>       {60, 13437},
>>       {65, 12500},
>>  };
>> +EXPORT_SYMBOL(ab8500_temp_tbl_a_thermistor);
>>
> Those exports should be in the previous patch where you start exporting the symbols,
> not in this patch.
>
Sorry, This was really my carelessness, will update it.

> Thanks,
> Guenter
