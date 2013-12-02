Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab3LBUsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:48:24 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:34058 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501Ab3LBUrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:47:55 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131202202120.GA23611@roeck-us.net>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
	<20131202202120.GA23611@roeck-us.net>
Date: Mon, 2 Dec 2013 12:47:53 -0800
Message-ID: <CAOesGMi-P6LG1-XKVizUS_qX-gfZi_iXBO5r+=6a2nfvBS60mw@mail.gmail.com>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Report when the watchdog reset the system
From: Olof Johansson <olof@lixom.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Doug Anderson <dianders@chromium.org>, Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 12:21 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Mon, Dec 02, 2013 at 10:14:41AM -0800, Doug Anderson wrote:
>> A good watchdog driver is supposed to report when it was responsible
>> for resetting the system.  Implement this for the s3c2410, at least on
>> exynos5250 and exynos5420 where we already have a pointer to the PMU
>> registers to read the information.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> This patch is based atop Leela Krishna's recent series that ends with
>> (ARM: dts: update watchdog device nodes for Exynos5250 and Exynos5420)
>> AKA <https://patchwork.kernel.org/patch/3251861/>.
>>
>>  drivers/watchdog/s3c2410_wdt.c | 42 +++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
>> index 47f4dcf..2c87d37 100644
>> --- a/drivers/watchdog/s3c2410_wdt.c
>> +++ b/drivers/watchdog/s3c2410_wdt.c
>> @@ -62,9 +62,13 @@
>>  #define CONFIG_S3C2410_WATCHDOG_ATBOOT               (0)
>>  #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME (15)
>>
>> +#define RST_STAT_REG_OFFSET          0x0404
>>  #define WDT_DISABLE_REG_OFFSET               0x0408
>>  #define WDT_MASK_RESET_REG_OFFSET    0x040c
>>  #define QUIRK_NEEDS_PMU_CONFIG               (1 << 0)
>> +#define QUIRK_HAS_RST_STAT           (1 << 1)
>> +#define QUIRKS_NEED_PMUREG           (QUIRK_NEEDS_PMU_CONFIG | \
>> +                                      QUIRK_HAS_RST_STAT)
>>
> I am not really happy about the NEED (both of them, really) here.
> How about HAS instead ?

Ah, I just commented on these things on our internal review site too
on this patch. I don't even think a quirk is needed -- just use the
presence of a non-0 rst_stat_reg to tell if you need to use regmap.


-Olof
