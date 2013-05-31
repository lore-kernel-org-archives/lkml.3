Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3EaO7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:59:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3EaO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:59:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Cc: Timur Tabi <timur@tabi.org>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 7/8] video: xilinxfb: Fix sparse warnings
Date: Fri, 31 May 2013 16:56:44 +0200
Message-ID: <1466524.sgAzczhnBg@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <51A8B220.6070308@monstr.eu>
References: <cover.1370004925.git.michal.simek@xilinx.com> <51A8A89C.8030404@tabi.org> <51A8B220.6070308@monstr.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BUY4YytEOl/q2Fa8eipIlzkhoHQ9Lth5LrYOb1KUEaz
 JTAZsN7GFl2Z+3T4J4RumW2TAw/C3P0+hQBFm7cpir+ohd54c1
 bQYFWkTwvje41angTzlAHhgOdmbYp8WgxEWwa2Bp4qeAQ+tE2F
 DVznusdn1DlqLou0YMR/KC90z6/DDUTJCsRqvNCZ7Ov6nDL4Zb
 aNBHA10nnpdLo6gVuSl3AM251waxagJa48TG4FYb+9JJLusJMJ
 Bybj5pbQLQbjbv/799RchUp8K+NwiloW1NLxaU9FbTFAQvE1zR
 ZH07H0yhCTWKQw9wlNg4gE9O5dszNVc/iO+p5ccsqn6kvA05mT
 wSDMWnWe8Ems1uCB9eGg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 16:22:24 Michal Simek wrote:
> @@ -307,7 +319,11 @@ static int xilinxfb_assign(struct platform_device *pdev,
> 
>         /* Fill struct fb_info */
>         drvdata->info.device = dev;
> -       drvdata->info.screen_base = (void __iomem *)drvdata->fb_virt;
> +       if (drvdata->fb_virt)
> +               drvdata->info.screen_base = (__force void __iomem *)
> +                                                       drvdata->fb_virt;
> +       else
> +               drvdata->info.screen_base = drvdata->fb_virt_io;

Yes, unfortunately, this is what all other frame buffer drivers do
at the moment. It is technically not correct, but most architectures
are able to call readl/writel on regular memory, or dereference
__iomem tokens, so we often get away with it. It's probably not
worth fixing it in the fbdev code base as that would be a huge
change, and people are migrating to DRM/KMS.

	Arnd
