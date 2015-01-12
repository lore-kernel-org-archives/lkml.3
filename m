Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbbALQ1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:27:14 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:61350 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbbALQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:27:10 -0500
MIME-Version: 1.0
In-Reply-To: <20150112162438.GA18723@roeck-us.net>
References: <20150112180322.003b44f2@canb.auug.org.au>
	<20150112162438.GA18723@roeck-us.net>
Date: Mon, 12 Jan 2015 17:27:08 +0100
X-Google-Sender-Auth: 3Lpq-yH8Vce5TI79k_GGlv2ZFRQ
Message-ID: <CAMuHMdUYEe=L=H75AOYVjinRSW=okRJNrNJVy-bY1gshdVrO7Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 12 (build failures: m68k, ppc)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-m68k <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 5:24 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Mon, Jan 12, 2015 at 06:03:22PM +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20150109:
>>
>> The usb-gadget-fixes tree gained a conflict against the usb.current tree.
>>
>> The net-next tree gained a build failure for which I reverted a commit.
>>
>> The pinctrl tree gained a build failure so I used the version from
>> next-20150109.
>>
>> The akpm tree lost a few patches that turned up elsewhere.
>>
>> Non-merge commits (relative to Linus' tree): 2202
>>  2272 files changed, 69868 insertions(+), 38441 deletions(-)
>>
>
> Build failures, seen since next-20150109:
>         m68k:allmodconfig
>         powerpc:ppc6xx_defconfig
>
> Due to:
>         ERROR: "__get_user_bad" [drivers/gpu/drm/drm.ko] undefined!
>         make[1]: *** [__modpost] Error 1
>
> Caused by commit d34f20d6e2f (drm: Atomic modeset ioctl).

Yeah, it needs a get_user() that supports 64-bit data.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
