Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3E0KcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:32:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50176 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3E0KcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:32:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
Date: Mon, 27 May 2013 12:32:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305262323.29519.arnd@arndb.de> <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
In-Reply-To: <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305271232.03644.arnd@arndb.de>
X-Provags-ID: V02:K0:ST5qXj1Gd3OfM47KCcaoRS7KahrC+j/iI19H0i6gWIz
 NvmQAhRTt2MpyBr/hbfhGWGSU6nu09c5vMwIblrFvLlqNGeTG9
 AeDjqv59taDo4kSAIN9Lc0d8P4M8WM/QbpRAPFsPzt0uD58/Bc
 1Q2yOdxrKCovewGQMYQB4JgFB+srlWiqLJ3YirtW6BrRVQOh4h
 6vPgCMapJvR9CTl+qZ5DfxBasOBbx+xWO/aXx4hMZWD2xxEkS9
 VVDVEReyBKHFx3BQXQlgcBmMARxq+dtiS9JCLGqjkTpuedB7Ij
 oeITQf5NGWcc1ykPdfKaBUWt1p7jYiiN6XobOcby7EzYnpQbbb
 kmFpLTlZ2CVGLbFgpCfU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013, Daniel Tang wrote:
> > On Saturday 25 May 2013, Daniel Tang wrote:

> > The one remaining bit that sticks out is the clcd platform data. As I
> > said before, I won't require you to convert that to DT in order to
> > get your code merged, but I'd also really like to see that happen,
> > as we will also need that to get rid of auxdata on the ARM reference
> > platforms (integrator, versatile, realview, vexpress).
> 
> How would you like me to convert the platform data to DT? AFAIK, the
> clcd driver isn't aware of DT so the only way is to use the AUXDATA right now.

There are two basica approaches we could take:

a) add DT support to the clcd driver, using the of_get_videomode()
helper and any other properties that need to be added.

b) add a new KMS driver for this hardware that can be used as an
alternative to the existing one and that works with DT.

	Arnd
