Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab3D3JjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:39:08 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49844 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3D3JjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <517F8FF4.3050901@atmel.com>
References: <517F8FF4.3050901@atmel.com>
Date: Tue, 30 Apr 2013 11:39:05 +0200
X-Google-Sender-Auth: hKSHR29kM3PM2hbW-r2N-5SMIlg
Message-ID: <CAMuHMdXYaDHYq7CG8ftP+yyF18pMx8qZrvM3AUTAXk+tUruNcA@mail.gmail.com>
Subject: Re: linux-next build error (at91) - use of bool in mach/arch.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jon Medhurst <tixy@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 11:33 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> So, I am wondering if the best correction is to add the types.h header file
> in the asm/mach/arch.h file, like this:
>
> --- a/arch/arm/include/asm/mach/arch.h
> +++ b/arch/arm/include/asm/mach/arch.h
> @@ -8,6 +8,8 @@
>   * published by the Free Software Foundation.
>   */
>
> +#include <linux/types.h>
> +
>  #ifndef __ASSEMBLY__
>
>  struct tag;
>
> or if a better option would be to re-arrange the include directives in
> various at91xxx_devices.c files?

Include files should be self-contained, so asm/mach/arch.h is the right place.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
