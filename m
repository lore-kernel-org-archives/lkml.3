Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3KRL7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:59:11 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33026 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3KRL67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <5289359B.8090506@broadcom.com>
References: <20131117133702.GA30840@pd.tnic>
	<5289359B.8090506@broadcom.com>
Date: Mon, 18 Nov 2013 12:58:58 +0100
Message-ID: <CACna6ryNX1=8zdYe2bjCj7aj3S_O=LnrxdjBcESvJJ63+h729Q@mail.gmail.com>
Subject: Re: [PATCH] brcmsmac: Fix build dep on LEDS_CLASS
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/17 Arend van Spriel <arend@broadcom.com>:
> On 11/17/13 14:37, Borislav Petkov wrote:
>>
>> From: Borislav Petkov<bp@suse.de>
>>
>> When building randconfigs with CONFIG_BCMA_DRIVER_GPIO=y, I get
>>
>> drivers/built-in.o: In function `brcms_led_unregister':
>> (.text+0x351aca): undefined reference to `led_classdev_unregister'
>> drivers/built-in.o: In function `brcms_led_register':
>> (.text+0x351c65): undefined reference to `led_classdev_register'
>>
>> during the final linking stage because brcmsmac/led.c needs LEDS_CLASS
>> for reg/dereg. Fix that.
>
>
> Wouldn't it be better to fix it in brcmsmac.

I agree. After all bcma doesn't use/register LEDs, so this should be
placed in drivers that do.

P.S.
Borislav: I think I didn't get your original patch.
