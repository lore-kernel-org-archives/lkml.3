Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3KSJLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:11:23 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3574 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab3KSJLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:11:19 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <528B2B2A.2030504@broadcom.com>
Date: Tue, 19 Nov 2013 10:11:06 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Borislav Petkov" <bp@alien8.de>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Fix build dep on LEDS_CLASS
References: <20131117133702.GA30840@pd.tnic>
 <5289359B.8090506@broadcom.com>
 <CACna6ryNX1=8zdYe2bjCj7aj3S_O=LnrxdjBcESvJJ63+h729Q@mail.gmail.com>
 <20131118133250.GH24851@pd.tnic> <20131118204003.GK24851@pd.tnic>
 <528A925C.20602@broadcom.com> <20131118233247.GM24851@pd.tnic>
In-Reply-To: <20131118233247.GM24851@pd.tnic>
X-WSS-ID: 7E95F4854RS9313675-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 12:32 AM, Borislav Petkov wrote:
> On Mon, Nov 18, 2013 at 11:19:08PM +0100, Arend van Spriel wrote:
>> what about:
>>
>> config BRCMSMAC
>>          tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
>>          depends on MAC80211
>>          depends on BCMA_POSSIBLE
>> +	select LEDS_CLASS if BCMA_DRIVER_GPIO
>> 	select BCMA
>
> I know, nice and short but too good to be true. LEDS_CLASS needs to pull
> in NEW_LEDS unfortunately:
>
> drivers/built-in.o: In function `set_brightness_delayed':
> led-class.c:(.text+0x4596e5): undefined reference to `led_stop_software_blink'
> drivers/built-in.o: In function `led_classdev_register':
> (.text+0x4598db): undefined reference to `leds_list_lock'
> drivers/built-in.o: In function `led_classdev_register':
> (.text+0x4598e7): undefined reference to `leds_list'
> drivers/built-in.o: In function `led_classdev_register':
> (.text+0x4598f3): undefined reference to `leds_list'
> drivers/built-in.o: In function `led_classdev_register':
> (.text+0x4598fa): undefined reference to `leds_list_lock'
> drivers/built-in.o: In function `led_classdev_register':
> (.text+0x459901): undefined reference to `leds_list'
> drivers/built-in.o: In function `led_classdev_unregister':
> (.text+0x4599a8): undefined reference to `led_stop_software_blink'
> drivers/built-in.o: In function `led_classdev_unregister':
> (.text+0x4599b2): undefined reference to `led_set_brightness'
> drivers/built-in.o: In function `led_classdev_unregister':
> (.text+0x4599c2): undefined reference to `leds_list_lock'
> drivers/built-in.o: In function `led_classdev_unregister':
> (.text+0x4599d6): undefined reference to `leds_list_lock'
> make: *** [vmlinux] Error 1
>
> What works, instead, is below. I think my "depends" solution from
> earlier takes care of this without you having to select other stuff
> explicitly but in the end of the day, I don't really care all that much
> which one you guys take.

The problem with 'select' is indeed that you need to cover all 
dependencies. It looks fine to me so why don't you just submit this to 
John Linville (and Cc: linux-wireless@vger.kernel.org).

Regards,
Arend

> --
> diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
> index b00a7e92225f..54e36fcb3954 100644
> --- a/drivers/net/wireless/brcm80211/Kconfig
> +++ b/drivers/net/wireless/brcm80211/Kconfig
> @@ -5,6 +5,8 @@ config BRCMSMAC
>          tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
>          depends on MAC80211
>          depends on BCMA
> +       select NEW_LEDS if BCMA_DRIVER_GPIO
> +       select LEDS_CLASS if BCMA_DRIVER_GPIO
>          select BRCMUTIL
>          select FW_LOADER
>          select CRC_CCITT
>


