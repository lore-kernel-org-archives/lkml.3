Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967844Ab3E3IIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:08:14 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39181 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967842Ab3E3IHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:07:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130530163334.105322d3c166b74165f1dad4@canb.auug.org.au>
References: <20130530163334.105322d3c166b74165f1dad4@canb.auug.org.au>
Date: Thu, 30 May 2013 10:07:48 +0200
X-Google-Sender-Auth: x-US5WeA6Ji2WtsxrepCizBRThY
Message-ID: <CAMuHMdXNzmJtfxzzt3kuzROzJmfsTKkp_4_8pdg=ahLv2LdU+Q@mail.gmail.com>
Subject: Re: linux-next: Tree for May 30
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 8:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Changes since 20130529:

The following defconfigs fail without anything useful in the log:
  - at91sam9g20_defconfig
  - at91sam9261_defconfig
  - at91sam9260_defconfig

A manual run reveals why:
Can't find default configuration "arch/arm/configs/at91sam9g20_defconfig"!

This is due to the merge of several config files:

commit b3f442b0eedbc20b5ce3f4a96530588d14901199
Author: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date:   Wed May 15 17:19:21 2013 +0200

    ARM: at91: udpate defconfigs

    Merge 9g20 with 9260 and 9g10 with 9261 as those SoCs can run from the same
    kernel even in non DT world.

    Fix the sam9261ek to allow 9g10 and sam9261 to compile together.

    Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

 arch/arm/configs/at91_dt_defconfig                 |   55 +++---
 arch/arm/configs/at91rm9200_defconfig              |  218 +++-----------------
 ...am9g20_defconfig => at91sam9260_9g20_defconfig} |   67 +++++--
 arch/arm/configs/at91sam9260_defconfig             |   91 --------
 ...am9261_defconfig => at91sam9261_9g10_defconfig} |   19 +--
 arch/arm/configs/at91sam9263_defconfig             |   39 ++---
 arch/arm/configs/at91sam9g45_defconfig             |   94 +++------
 arch/arm/configs/sama5_defconfig                   |   35 +++-
 arch/arm/mach-at91/Kconfig.non_dt                  |  159 +++++++--------
 arch/arm/mach-at91/Makefile                        |    2 -
 arch/arm/mach-at91/board-sam9261ek.c               |   28 ++--
 11 files changed, 268 insertions(+), 539 deletions(-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
