Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3E3NVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:21:05 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:50207 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3E3NU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:20:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130529155018.GE3012@gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
	<1369834407-30762-2-git-send-email-gabriel.fernandez.st@gmail.com>
	<20130529155018.GE3012@gmail.com>
Date: Thu, 30 May 2013 15:20:55 +0200
Message-ID: <CAGo1xzDB-uGsMANghtqX-rX6GuhmHKo1Z=ywtC=TXfx6eM_ALQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: ux540: Add ccu8540-uib-v3 Device Tree Machine
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2013 17:50, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 29 May 2013, Gabriel Fernandez wrote:
>
>> From: Gabriel Fernandez <gabriel.fernandez@st.com>
>>
>> This board includes the U8540 platform and specifies only the
>> ST-Ericsson UIB version 3.
>
> I'm confused by this.
>
> Is it a new board, or just a UIB?

For me it's a new board.

ccu8540.dts is a board without uib.
You can can plug on this board some different uibs.
That's why, i created a ccu8540-uib-v3.dts board in which i included a
common board ccu8540.dts

Another solution is to create one *.dtsi file with all uibs for
ccu8540 and makes a dynamique detection.
Linus, Lee  what do you think about that ?

>
>> ---
>>  arch/arm/boot/dts/Makefile           |  1 +
>>  arch/arm/boot/dts/ccu8540-uib-v3.dts | 16 ++++++++++++++++
>>  2 files changed, 17 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/ccu8540-uib-v3.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 1995988..29cb5db 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -159,6 +159,7 @@ dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
>>       hrefprev60.dtb \
>>       hrefv60plus.dtb \
>>       ccu8540.dtb \
>> +     ccu8540-uib-v3.dtb      \
>>       ccu9540.dtb
>>  dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
>>       r8a7740-armadillo800eva.dtb \
>> diff --git a/arch/arm/boot/dts/ccu8540-uib-v3.dts b/arch/arm/boot/dts/ccu8540-uib-v3.dts
>> new file mode 100644
>> index 0000000..4b4982e
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/ccu8540-uib-v3.dts
>
> If this is a UIB, it should be an include file (*.dtsi).
>
>> @@ -0,0 +1,16 @@
>> +/*
>> + * Copyright 2012 ST-Ericsson AB
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +
>> +#include "ccu8540.dts"
>
> No, the other way round.
>
> ccu8540.dts should include this one.
>
>> +/ {
>> +     model = "ST-Ericsson U8540 platform with device tree UIB v3";
>> +};
>
> This patch doesn't actually do anything.
>
> Fix it up, so it at least as some functionality.
>
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
