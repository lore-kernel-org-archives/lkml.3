Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBGJld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:41:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaBGJla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:41:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] backlight: add PWM dependencies
Date: Fri, 7 Feb 2014 10:40:57 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Eric Miao'" <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org> <201402061708.05845.arnd@arndb.de> <000d01cf23b1$7c1f8de0$745ea9a0$%han@samsung.com>
In-Reply-To: <000d01cf23b1$7c1f8de0$745ea9a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402071040.58087.arnd@arndb.de>
X-Provags-ID: V02:K0:X5/u3LSn0QpryvG6eXioaExW91lsuJL2sSpuSC2gK1Y
 +FoENPyzQugbI/6wc6azzsH0eKEyix4fqm4ehI/Al73rak5t9x
 dKloL1fs8aQlbm6Z1tSnoEYMQ+4bVWAiac9LjtbEbQ9dtXXavI
 07se0l7SZfcIYqX2nZ5kL9fUCfZr7qu2rcKIMVNznDPqoJr2Hq
 HXnwzP600dKw1JnQqfUAzYTr/yc0LpPOv73EVI6XklJwFP5oC+
 GspkQHI+qgy31zBCmRa5tTF8nuA6e20E2DSkIhnl9ezJ/2pC2D
 CPQr/2VMq2lK2Q2elOK0yKNZLighaCnwFAsex5PDHi/Z3iUVnI
 Ql9tcTqS4In0kQi1/tjI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 February 2014, Jingoo Han wrote:
> How about the following?
> 
>   [PATCH 1/7] ARM: pxa: don't select HAVE_PWM
>   [PATCH 2/7] ARM: lpc32xx: don't select HAVE_PWM
>   [PATCH 3/7] ARM: remove HAVE_PWM config option
>   [PATCH 4/7] MIPS: jz4740: don't select HAVE_PWM
>   [PATCH 5/7] Input: max8997_haptic: remove HAVE_PWM dependencies
>   [PATCH 6/7] Input: pwm-beepe: remove HAVE_PWM dependencies
>   [PATCH 7/7] pwm: don't use IS_ENABLED(CONFIG_HAVE_PWM)
> 
> I would like to merge it through PWM tree.
> After merging these patches, all HAVE_PWM will be removed from
> the mainline kernel. Thank you. :-)

Sounds godo to me, thanks a lot for taking care of this!
I don't see any inter-dependencies between the various patches,
so we could also take the first three through the arm-soc tree
to avoid conflicts with other changes (or possibly the third
one through rmk's ARM tree, if he prefers).

	Arnd
