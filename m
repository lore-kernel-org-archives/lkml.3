Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaLTUHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:07:21 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54758 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaLTUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:07:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Hengelein <stefan.hengelein@fau.de>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org, kgene@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] ARM: SAMSUNG: remove dead #elif CONFIG_S3C24XX_DMAC
Date: Sat, 20 Dec 2014 21:06:17 +0100
Message-ID: <23285910.CzU2Gzn1KL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CABv5NL_GisHMZVK03M3j_cGMVcoZ7L+Czt5TP2Sp4abBeUxuCQ@mail.gmail.com>
References: <1418830837-7422-1-git-send-email-stefan.hengelein@fau.de> <1645416.VNQj8YWB7M@phil> <CABv5NL_GisHMZVK03M3j_cGMVcoZ7L+Czt5TP2Sp4abBeUxuCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Rz9hb2NaBXQmvcYOaqZ2psCa4euQLv3K6YFOQu8DehHovsXNmfv
 em2NIBYZ4vp+MRHzaWDQj+SJBCRLyVTkJ9vOHWgHwA5HMWmkJN4vIxgy5ymGH4DFYx4YDhw
 KFUYpAV/nK8nRJKEXa6oR12nfm+VHbx15NqEU9csVJX/3FoOks25pmTTyRNUpFo8Enx/kwz
 pZBxSDAjacSYlVaDEwGxw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 December 2014 15:15:09 Stefan Hengelein wrote:
> From what i can see, the block was already dead when it was introduced.
> d2193ce2 changed the "if ARCH_S3C64XX" into the Kconfig file itself,
> before it was around the source statement in arch/arm/Kconfig
> 
> if there are really just downstream users that explicitly have to add
> a statement to select S3C64XX_DEV_SPI0 and therefore add the
> possibility to enable the block i want to remove, i'd argue that these
> downstream users could also add the block itself. I'm not sure how
> intuitive it might be for downstream users to add a select in Kconfig
> to enable their machine to communicate with a device, but i'm also not
> familiar with the hardware we're talking about.
> 
> However, i'd prefer to have a consistent upstream state and leave
> these problems to downstream users, but that's for the Maintainer to
> decide 

In general, I totally agree: dead code should be eliminated and out of
tree users of dead code can add it back as a patch.

However, in this case, I'd lean more towards leaving the code in there,
basically because the current code correctly documents what the hardware
requirements are, and that is helpful even for reading the code when you
work on DT based support for the same hardware. Eventually we will be
able to remove the entire function.

	Arnd
