Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaHNAN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:13:26 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48623 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaHNANY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <1786859.jGWg0DZRp1@wuerfel>
References: <1407951153-918-1-git-send-email-abrestic@chromium.org>
	<CAGOxZ51_cr_j5vWrNO_ZnfAQsvt8zfEjQZC2f-nWv4w9b5R1kQ@mail.gmail.com>
	<1786859.jGWg0DZRp1@wuerfel>
Date: Wed, 13 Aug 2014 17:13:23 -0700
X-Google-Sender-Auth: KGxrZDI5gU7J2JkpcGHsojIPKrw
Message-ID: <CAL1qeaFgySoDs_PWA5FtDK0JQMVoFFfgLbOBz6-dshEg7NCdhQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Remove architecture dependency
From: Andrew Bresticker <abrestic@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alim Akhtar <alim.akhtar@gmail.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In general, it's best to have specific dependencies on the subsystem
> a driver uses. You probably need something like
>
>         depends on HAS_IOMEM && COMMON_CLK && REGULATOR
>         depends on COMPILE_TEST || ARC || ARM || MIPS
>
> to cover all the possible cases. The specific options are probably
> not the ones I listed above, but you should get the idea. Most importantly,
> you don't want to allow building the driver on architectures on which
> it can't compile.

The only compile-time dependencies I see are HAS_IOMEM (which MMC
already depends on) and HAS_DMA.  There isn't any compile-time
dependency on COMMON_CLK, REGULATOR, GPIOLIB, OF, etc.  I've compiled
it successfully for a few non-ARM/ARC architectures, though that
certainly isn't an exhaustive test.  To be safe though, perhaps I'll
just update the architecture dependency to include MIPS ||
COMPILE_TEST as you suggested.
