Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3KSIUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:20:44 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44411 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3KSIUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:20:42 -0500
MIME-Version: 1.0
In-Reply-To: <528AA08C.6080608@wwwdotorg.org>
References: <1384795559-2116-1-git-send-email-mmarek@suse.cz>
	<528AA08C.6080608@wwwdotorg.org>
Date: Tue, 19 Nov 2013 09:20:41 +0100
X-Google-Sender-Auth: Xtsl6feL0kG9ZV4rHW-T1RULhlY
Message-ID: <CAMuHMdVkWmYGM5XvH0f41JdwK_g-PdvdDBzR8uJWn0wYBQrAcg@mail.gmail.com>
Subject: Re: [PATCH] mfd: Make MFD_AS3722 depend on I2C=y
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, ldewangan@nvidia.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 12:19 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/18/2013 10:25 AM, Michal Marek wrote:
>> MFD_AS3722 can only be builtin, so it needs I2C builtin as well.
>> With I2C=m, we get:
>>
>> drivers/mfd/as3722.c:372: undefined reference to `devm_regmap_init_i2c'
>> drivers/built-in.o: In function `as3722_i2c_driver_init':
>> drivers/mfd/as3722.c:444: undefined reference to `i2c_register_driver'
>> drivers/built-in.o: In function `as3722_i2c_driver_exit':
>> drivers/mfd/as3722.c:444: undefined reference to `i2c_del_driver'
>
> Shouldn't Kconfig handle this; if a Boolean config option depends on a
> tri-state config option, shouldn't it automatically validate that the
> tri-state is "y" not "m"?

Unfortunately not. While tristate is always used to declare code modules,
bool can be used to declare two different things: code modules or optional
features.

For optional features, "depends on x" means "depends on x=y or x=m".
For code modules, "depends on x" should really by "depends on x=y".

To handle this automatically, we need to introduce a new Kconfig symbol,
and convert all the thousands existing ones...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
