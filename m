Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbaEMNLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:11:36 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34766 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900AbaEMNLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405131405590.6261@ionos.tec.linutronix.de>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<5371EAEB.5030100@imgtec.com>
	<CAFiDJ58w31gm_z3Y1Q6ZREQPW4F6uVB+vy3X1r_3kLgaEE3O1w@mail.gmail.com>
	<4465265.lUhYuYrZG4@wuerfel>
	<alpine.DEB.2.02.1405131405590.6261@ionos.tec.linutronix.de>
Date: Tue, 13 May 2014 15:11:33 +0200
X-Google-Sender-Auth: HEzx3hvP0FAIi2KR9T9TEUZ6VdI
Message-ID: <CAMuHMdV2NPwacZwP=QRP+d+eFT85jDq9V0F+Q+Hdch3xukpbkw@mail.gmail.com>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        James Hogan <james.hogan@imgtec.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 2:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 13 May 2014, Arnd Bergmann wrote:
>> On Tuesday 13 May 2014 18:17:40 Ley Foon Tan wrote:
>> > When we export this posix_types.h file for user software, they need to
>> > define this config, eg: CONFIG_32BIT_TIME to use 32 bit time. Is this
>> > what we want to do?
>>
>> No, this doesn't really work: You can't use CONFIG_* symbols in
>> user-visible header files.
>
> Then make the config symbol generate the header from a template.

Indeed. I think it's worthwhile to add CONFIG_* expansion for such "hard"
CONFIG symbols to make headers_install, cfr. the existing unifdef support.

We do such a hard work to improve asm-generic, so new architectures can
just use that, only to see early adaptors now having to migrate away from it
(e.g. OpenRISC suddenly gaining uapi/asm/posix_types.h).

Or is there another solution?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
