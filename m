Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaICIWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:22:22 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:46383 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaICIWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <3749760.naNt3fHoTI@wuerfel>
References: <1409671320-7604-1-git-send-email-ch.naveen@samsung.com> <3749760.naNt3fHoTI@wuerfel>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 3 Sep 2014 13:51:56 +0530
Message-ID: <CAHfPSqAn5gHjDA75Zf1W5=GH9_W+X6+4oc9rDK7CqeSoF3DURw@mail.gmail.com>
Subject: Re: [PATCH] tty/serial: fix config dependencies for samsung serial
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-serial@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Pankaj Dubey <pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 2 September 2014 21:16, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 02 September 2014 20:52:00 Naveen Krishna Chatradhi wrote:
>> Make the config symbols SERIAL_SAMSUNG_UARTS_4 and
>> SERIAL_SAMSUNG_UARTS depend on SERIAL_SAMSUNG rather than
>> PLAT_SAMSUNG.
>
> Please always describe why you are doing a change. This patch
> seems really pointless.

The SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS config options are
meaningful only if SERIAL_SAMSUNG is enabled. Hence the dependency
rules were changed. I will repost this patch with better description.

>
>>  config SERIAL_SAMSUNG_UARTS_4
>>         bool
>> -       depends on PLAT_SAMSUNG
>> +       depends on SERIAL_SAMSUNG
>>         default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
>>         help
>>           Internal node for the common case of 4 Samsung compatible UARTs
>>
>>  config SERIAL_SAMSUNG_UARTS
>>         int
>> -       depends on PLAT_SAMSUNG
>> +       depends on SERIAL_SAMSUNG
>>         default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
>>         default 3
>>         help
>>
>
> Have you checked that it still builds on all samsung platforms when
> SERIAL_SAMSUNG is disabled? We have had build errors in this area
> in the past.

Yes, it builds for other Samsung platforms.

>
>         Arnd

Thanks.

-- 
Shine bright,
(: Nav :)
