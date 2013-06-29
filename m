Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3F2I0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 04:26:07 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61567 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3F2I0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 04:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <51CE9442.2020105@gmail.com>
References: <51C548E2.1060104@asianux.com>
	<51C54A9B.9060009@asianux.com>
	<51CE9442.2020105@gmail.com>
Date: Sat, 29 Jun 2013 10:26:02 +0200
X-Google-Sender-Auth: xYSzcTvvNOk6URrTmhaZCI3hH3I
Message-ID: <CAMuHMdVAQJWDem0=uMnH7iVrckxPJ9cPn=8pYOusNov+wW5VeA@mail.gmail.com>
Subject: Re: [PATCH] arch: m68k: include: asm: define 'VM_DATA_DEFAULT_FLAGS'
 no matter whether has 'NOMMU' or not.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Chen Gang <gang.chen@asianux.com>, linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 10:01 AM, Michael Schmitz <schmitzmic@gmail.com> wrote:
>> The same .config file, also report the compiling error below:
>>
>> drivers/i2c/busses/i2c-ocores.c:81:2: error: implicit declaration of
>> function ‘iowrite8’ [-Werror=implicit-function-declaration]
>> drivers/i2c/busses/i2c-ocores.c:86:2: error: implicit declaration of
>> function ‘iowrite16’ [-Werror=implicit-function-declaration]
>> drivers/i2c/busses/i2c-ocores.c:91:2: error: implicit declaration of
>> function ‘iowrite32’ [-Werror=implicit-function-declaration]
>> drivers/i2c/busses/i2c-ocores.c:96:2: error: implicit declaration of
>> function ‘ioread8’ [-Werror=implicit-function-declaration]
>> drivers/i2c/busses/i2c-ocores.c:101:2: error: implicit declaration of
>> function ‘ioread16’ [-Werror=implicit-function-declaration]
>> drivers/i2c/busses/i2c-ocores.c:106:2: error: implicit declaration of
>> function ‘ioread32’ [-Werror=implicit-function-declaration]
>>
>> Excuse me, I am not quite familiar with the related hardware and m68k,
>> I guess under m68k architecture, we need not this drivers, is it correct ?

Until someone synthesizes the OpenCores i2c core together with the
OpenCores 68000 core (they seem to have one), and tries to run uClinux
on it...

> That would be correct, yes. Perhaps add appropriate dependencies in
> drivers/i2c/Kconfig to allow building I2C drivers
> only on hardware that supports it?

We still want it for compile-coverage.

Now, the issue is that m68knommu doesn't implement ioread8() and
friends, so I'm adding the uClinux list.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
