Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3HWNFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:05:09 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60331 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3HWNFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:05:08 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZdzF-HqTmEWpYiBe2VwGN23fsnWCr7aqE0NYWpBfHsfw@mail.gmail.com>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
	<1377260620-18829-34-git-send-email-lee.jones@linaro.org>
	<CACRpkdZdzF-HqTmEWpYiBe2VwGN23fsnWCr7aqE0NYWpBfHsfw@mail.gmail.com>
Date: Fri, 23 Aug 2013 15:05:07 +0200
Message-ID: <CACRpkdZE1yCPO0JVXX88SUKsp3ow7WBuJZZ=BEVk-c5=TOUO-A@mail.gmail.com>
Subject: Re: [PATCH 33/40] ARM: ux500: Don't register the STMPE/SKE when
 booting with ATAG support
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 2:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Aug 23, 2013 at 2:23 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> It's time to remove all ATAG support from ux500 and rely solely on
>> Device Tree booting. This patch is part of that endeavour.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
>> -/* STMPE/SKE keypad use this key layout */
>> -static const unsigned int mop500_keymap[] = {
>> -       KEY(2, 5, KEY_END),
>> -       KEY(4, 1, KEY_POWER),
>> -       KEY(3, 5, KEY_VOLUMEDOWN),
>> -       KEY(1, 3, KEY_3),
>> -       KEY(5, 2, KEY_RIGHT),
>> -       KEY(5, 0, KEY_9),
>> -
>> -       KEY(0, 5, KEY_MENU),
>> -       KEY(7, 6, KEY_ENTER),
>> -       KEY(4, 5, KEY_0),
>> -       KEY(6, 7, KEY_2),
>> -       KEY(3, 4, KEY_UP),
>> -       KEY(3, 3, KEY_DOWN),
>> -
>> -       KEY(6, 4, KEY_SEND),
>> -       KEY(6, 2, KEY_BACK),
>> -       KEY(4, 2, KEY_VOLUMEUP),
>> -       KEY(5, 5, KEY_1),
>> -       KEY(4, 3, KEY_LEFT),
>> -       KEY(3, 2, KEY_7),
>> -};
>
> This STMPE1601 keypad @0x40 and UIB encoding for
> the U8500 UIB does not exist in any DTS file does it? This
> means that the support for this UIB is effectively terminated.

You are wrong. Go read arch/arm/boot/dts/[ste-]stuib.dtsi.

Anyway, what you wanted to say was for these to be marked
"disabled" by default and turned into "okay" using an I2C
probe operation.

Yours,
Linus Walleij
