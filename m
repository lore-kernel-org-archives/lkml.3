Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaIXPJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:09:32 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60743 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaIXPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:09:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, u.kleine-koenig@pengutronix.de,
        gerg@uclinux.org, Olof Johansson <olof@lixom.net>,
        ARM Maintainers <arm@kernel.org>, linux-kernel@vger.kernel.org,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC PATCH] ARM: at91: remove no-MMU at91x40 support
Date: Wed, 24 Sep 2014 17:09:14 +0200
Message-ID: <3874734.x93Q9kHIES@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5422DD2F.4090308@atmel.com>
References: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com> <3700375.DRR5iB2NGi@wuerfel> <5422DD2F.4090308@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nb+Zt9E9CWQI5LeQD8B1P0SA5T5zzoERGxZR6sdD3YF
 65sCsiA99AgYzBOS+9haic6m3cJtZ3EPmGduDAHZY1FLKIqFbX
 UW7vjX2f0qIZPPtVnseNuWFAP2x0jcHAnw5K1/dURTlvlNIAyH
 FbYi/z0D7xP4padMQnlcF+8WPZuf9k1hp7KWuYBkoBapv5wcOX
 YL0/wqxL4Ka6eKzK5pfYDN8icfYjb//5gt12Q9+d2Szg9hBE4N
 PmVI8Fewdh+pSxWcVOyOsZsddF804NOUcjPnWJDvXwI1Z+WFjf
 dmy2KNN20ptVlO60c4hattjaBgf+k8/63DQyFP49zpYu4nJ07I
 O2iDaijd+eqVgp1ONtF0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 17:03:11 Nicolas Ferre wrote:
> > I think these can be simplified further: AT91_SAM9G45_RESET and
> > AT91_SAM9_ALT_RESET can just go away and the files put into
> > obj-y.
> 
> Yes, I had the same idea before realizing that these two directives will
> move away in a patch already sent for 3.18. So, as this material is
> probably 3.19-ish, I kept them as they are and keep in mind to remove
> them when I merge them with 3.18-rc1...

Ok.

> > OLD_CLK_AT91 is the same as AT91_USE_OLD_CLK, so you could
> > just use that instead. I suspect the 'USE_OF' dependency for
> > COMMON_CLK_AT91 can also go away, since all platforms are
> > either board file based and select AT91_USE_OLD_CLK, or they
> > are DT based and don't.
> 
> Here also, I didn't want to touch more because we need to remove the
> arch/arm/mach-at91/Kconfig.non_dt file very soon (3.19) and I don't want
> to change this file (or all the SoC files) before the chunks related to
> these directives simply go away.
> 
> Tell me if it makes sense.

Yes, I agree your approach is better then.

	Arnd
