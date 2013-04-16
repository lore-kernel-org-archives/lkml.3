Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016Ab3DPS4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:56:14 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:42095 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934781Ab3DPS4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:56:13 -0400
Date: Tue, 16 Apr 2013 20:56:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        linux-sh@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.9-rc7
In-Reply-To: <alpine.DEB.2.00.1304162052210.2338@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1304162052420.2358@ayla.of.borg>
References: <alpine.DEB.2.00.1304162052210.2338@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.9-rc7 to v3.9-rc6[3], the summaries are:
>   - build errors: +8/-10

  + drivers/pcmcia/electra_cf.c: error: implicit declaration of function '__ioremap_at' [-Werror=implicit-function-declaration]:  => 225:2
  + drivers/pcmcia/electra_cf.c: error: implicit declaration of function '__iounmap_at' [-Werror=implicit-function-declaration]:  => 316:3
  + drivers/pcmcia/electra_cf.c: error: implicit declaration of function 'in_le32' [-Werror=implicit-function-declaration]:  => 70:2
  + drivers/pcmcia/electra_cf.c: error: implicit declaration of function 'ioremap' [-Werror=implicit-function-declaration]:  => 213:2  + drivers/pcmcia/electra_cf.c: error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]:  => 318:3
  + drivers/pcmcia/electra_cf.c: error: implicit declaration of function 'out_le32' [-Werror=implicit-function-declaration]:  => 147:2

powerpc-randconfig

>   - build warnings: +164/-34

And my eye fell on this one:

  + include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5

sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6094/ (all 118 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6063/ (all 118 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
