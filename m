Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3KZIUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:20:00 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62549 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3KZIT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:19:59 -0500
MIME-Version: 1.0
In-Reply-To: <52944976.4060003@monstr.eu>
References: <1385094870-6962-1-git-send-email-stefan.kristiansson@saunalahti.fi>
	<52944976.4060003@monstr.eu>
Date: Tue, 26 Nov 2013 09:19:58 +0100
X-Google-Sender-Auth: G7U_P2R2bZL01Yy9WvY4ruYflHQ
Message-ID: <CAMuHMdVx_jkUMB=gS0CtguBPB4f3fNRx0z4hB4zRz9OC09SvsQ@mail.gmail.com>
Subject: Re: [PATCH v3] video: add OpenCores VGA/LCD framebuffer driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 8:10 AM, Michal Simek <monstr@monstr.eu> wrote:
> On 11/22/2013 05:34 AM, Stefan Kristiansson wrote:
> This construction seems to me too complicated and can be simpler.
>
> What about this?
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

Don't forget to check for res being non-NULL here.

>         res->flags &= ~IORESOURCE_CACHEABLE;
>         fbdev->regs = devm_ioremap_resource(&pdev->dev, res);
>         if (IS_ERR(fbdev->regs))
>                 return PTR_ERR(fbdev->regs);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
