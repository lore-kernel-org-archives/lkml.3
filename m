Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaGEOGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 10:06:41 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:53902 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaGEOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 10:06:40 -0400
MIME-Version: 1.0
Date: Sat, 5 Jul 2014 16:06:38 +0200
X-Google-Sender-Auth: hcVVE0O40knXiMOwlSCJC-ObT9w
Message-ID: <CAMuHMdU7atw4_04ojmAZ7+M=PVm1gOybtSs-oSg=0iYu0HpP3w@mail.gmail.com>
Subject: Validating monitor timings (was: Re: [PATCH] video: fbdev: amifb.c:
 Cleaning up variable that is never used)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2014 at 4:04 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, Jul 5, 2014 at 2:13 PM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
>> From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>
>>
>> Variable ar assigned a value that is never used.
>> I have also removed all the code that thereby serves no purpose.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
>> --- a/drivers/video/fbdev/amifb.c
>> +++ b/drivers/video/fbdev/amifb.c
>> @@ -1124,7 +1124,6 @@ static int ami_decode_var(struct fb_var_screeninfo *var, struct amifb_par *par,
>>  {
>>         u_short clk_shift, line_shift;
>>         u_long maxfetchstop, fstrt, fsize, fconst, xres_n, yres_n;
>> -       u_int htotal, vtotal;
>
> These became unused by commit 3161986224a3faa8ccca3e665b7404d81e7ee3cf
> Author: Geert Uytterhoeven <geert@linux-m68k.org>
> Date:   Wed Dec 13 00:35:54 2006 -0800
>
>     [PATCH] fbdev: remove references to non-existent fbmon_valid_timings()
>
>     Remove references to non-existent fbmon_valid_timings()

These days there's fb_validate_mode(), but very few drivers call that.
Or perhaps this should be handled by the fbdev core instead?
But there's potential for regressions here, as monspecs may not be set at all
with some drivers, and the default assumptions in fb_validate_mode() may not
be valid.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
