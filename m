Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3KWUMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 15:12:46 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50864 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab3KWUMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 15:12:45 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52910C3C.5020408@roeck-us.net>
Date: Sat, 23 Nov 2013 12:12:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>, Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: New build failures in v3.13-rc1
References: <5290F68C.4060900@roeck-us.net> <CAMuHMdW-YO6WyL3F7M+q5PqATPwxD9zKLtA3tCc9-Z2wKo-mPg@mail.gmail.com>
In-Reply-To: <CAMuHMdW-YO6WyL3F7M+q5PqATPwxD9zKLtA3tCc9-Z2wKo-mPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 10:51 AM, Geert Uytterhoeven wrote:
> On Sat, Nov 23, 2013 at 7:40 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> drivers/tty/ehv_bytechan.c:363:1: error: type defaults to 'int' in
>> declaration of 'console_initcall' [-Werror=implicit-int]
>>
>> Not really surprising as console_initcall() is not defined for modules.
>> I am a bit at loss why this is only seen now, though.
>
> On kissb that's been seens since v3.2-rc1.
>

This used to be a warning, now it is an error.

It is a side effect / result of commit 8097047217 (Makefile: enable -Werror=implicit-int
and -Werror=strict-prototypes by default). Reverting that commit fixes
this build problem, only to uncover the problem also seen with xtensa:allmodconfig:

drivers/built-in.o: In function `as3722_i2c_probe':
drivers/mfd/as3722.c:372: undefined reference to `.devm_regmap_init_i2c'
drivers/built-in.o: In function `as3722_i2c_driver_init':
drivers/mfd/as3722.c:444: undefined reference to `.i2c_register_driver'
drivers/built-in.o: In function `as3722_i2c_driver_exit':
drivers/mfd/as3722.c:444: undefined reference to `.i2c_del_driver'

Guenter

