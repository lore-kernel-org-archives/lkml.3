Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaIFSOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 14:14:20 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61021 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaIFSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 14:14:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140906153245.GA25739@roeck-us.net>
References: <20140905165052.GF29327@sirena.org.uk>
	<20140906153245.GA25739@roeck-us.net>
Date: Sat, 6 Sep 2014 20:14:17 +0200
X-Google-Sender-Auth: YpsGPUQ91c9LbxbTaTgt6b9EqsY
Message-ID: <CAMuHMdVrr5H7iij45QR+opMdUy16mJjiXngis1+x_=SK=6wggQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Sep 5: build error due to 'ath5k: added
 debugfs file for dumping eeprom'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Brown <broonie@kernel.org>, Jade Bilkey <herself@thefumon.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 5:32 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> I see the following build error on linux-next-20140905.
>
> Guenter
>
> ---
>
> Building alpha:allmodconfig ... failed
> Building sparc64:allmodconfig ... failed
>
> drivers/net/wireless/ath/ath5k/debug.c: In function 'open_file_eeprom':
> drivers/net/wireless/ath/ath5k/debug.c:933:2: error:
>         implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
> drivers/net/wireless/ath/ath5k/debug.c:933:6: warning:
>         assignment makes pointer from integer without a cast [enabled by default]
> drivers/net/wireless/ath/ath5k/debug.c:960:2: error:
>         implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

Missing #include <linux/vmalloc.h>?

> make[5]: *** [drivers/net/wireless/ath/ath5k/debug.o] Error 1
> make[4]: *** [drivers/net/wireless/ath/ath5k] Error 2
> make[3]: *** [drivers/net/wireless/ath] Error 2
>
> Bisect results:
>
> db906eb2101b0564b0c65edf4a8647395196342e is the first bad commit
> commit db906eb2101b0564b0c65edf4a8647395196342e
> Author: Jade Bilkey <herself@thefumon.com>
> Date:   Sat Aug 30 15:14:14 2014 -0400
>
> ath5k: added debugfs file for dumping eeprom
>
> Signed-off-by: Jade Bilkey <herself@thefumon.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>




-- 
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
