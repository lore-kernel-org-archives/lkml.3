Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3GYKJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:09:44 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62972 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3GYKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <51EF8F27.3030003@monstr.eu>
References: <ed64cda456be840147ae1f04bec6a99733f41c24.1374643896.git.michal.simek@xilinx.com>
	<007401ce8833$22ce0600$686a1200$@samsung.com>
	<51EF7FBD.8070103@monstr.eu>
	<51EF8530.90809@monstr.eu>
	<003a01ce8845$06df46e0$149dd4a0$@samsung.com>
	<51EF8F27.3030003@monstr.eu>
Date: Thu, 25 Jul 2013 12:09:39 +0200
X-Google-Sender-Auth: 4TMu_VS3oDZlZM5sHLFAOpKamFo
Message-ID: <CAMuHMdXnkN39A1z-Ejd247KHs-=kVBcBX0rbSp=gtye=E-Wzow@mail.gmail.com>
Subject: Re: [PATCH] video: xilinxfb: Fix compilation warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Jingoo Han <jg1.han@samsung.com>, Michal Simek <michal.simek@xilinx.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:24 AM, Michal Simek <monstr@monstr.eu> wrote:
>> Just now, I tested that the same problem happens on ARM config.
>> Also, I solved it by adding '&' operator.
>>
>> '&' operator is necessary as below:
>>
>>         dev_dbg(dev, "regs: phys=%pa, virt=%p\n",
>>                  &drvdata->regs_phys, drvdata->regs);
>>                 ^^^
>>
>>         dev_dbg(dev, "fb: phys=%pa, virt=%p, size=%x\n",
>>                 &drvdata->fb_phys, drvdata->fb_virt, fbsize);
>>                ^^^
>
> ok.
>
> The truth is as I said there are just 5 files in the whole kernel
> which are using %pa and if %pa is right way to go we should
> probably fix all off them.

"%pa" is a quite recent addition (v3.9).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
