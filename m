Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaDFNRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:17:09 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46538 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDFNRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <1398516318.KXtUGEPAeQ@wuerfel>
References: <1398516318.KXtUGEPAeQ@wuerfel>
Date: Sun, 6 Apr 2014 15:17:05 +0200
X-Google-Sender-Auth: 0Dj-1u39K_66E8B1H3slyVf9xlw
Message-ID: <CAMuHMdU2izuWReTnuMxz=o7HYNuonYsvekAzd_RU7Qec7f0oug@mail.gmail.com>
Subject: Re: [PATCH] staging: gs_fpgaboot: remove __TIMESTAMP__ macro
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Insop Song <insop.song@gainspeed.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 4:48 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> We specifically build the kernel with -Werror=date-time to detect
> such macros, which gives us this error:
>
> gs_fpgaboot/gs_fpgaboot.c:376:44: error: macro "__TIMESTAMP__" might prevent reproducible builds [-Werror=date-time]
>   pr_info("built at %s UTC\n", __TIMESTAMP__);

Worse, gcc 4.1.2 doesn't seem to understand __TIMESTAMP__:

drivers/staging/gs_fpgaboot/gs_fpgaboot.c: In function ‘gs_fpgaboot_init’:
drivers/staging/gs_fpgaboot/gs_fpgaboot.c:376: error: ‘__TIMESTAMP__’
undeclared (first use in this function)
drivers/staging/gs_fpgaboot/gs_fpgaboot.c:376: error: (Each undeclared
identifier is reported only once
drivers/staging/gs_fpgaboot/gs_fpgaboot.c:376: error: for each
function it appears in.)

> The obvious fix is to remove the printk output line.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
> index 89bc84d..7506900 100644
> --- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
> +++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
> @@ -373,7 +373,6 @@ static int __init gs_fpgaboot_init(void)
>         r = -1;
>
>         pr_info("FPGA DOWNLOAD --->\n");
> -       pr_info("built at %s UTC\n", __TIMESTAMP__);
>
>         pr_info("FPGA image file name: %s\n", file);
>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
