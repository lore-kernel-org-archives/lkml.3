Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3I0ORw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:17:52 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52862 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3I0ORu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:17:50 -0400
MIME-Version: 1.0
In-Reply-To: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
Date: Fri, 27 Sep 2013 16:17:49 +0200
Message-ID: <CACRpkdYbCzOJ9k8AyriM9quafx=dseK6w1DYjyrJ9F53ka8TEw@mail.gmail.com>
Subject: Re: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on S3C24XX.
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:46 AM, José Miguel Gonçalves
<jose.goncalves@inov.pt> wrote:

> Some GPIO line limits are incorrectly set which, for instance,
> does not allow nRTS1 (GPH11) configuration on a S3C2416 chip.
>
> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> ---
>  arch/arm/mach-s3c24xx/include/mach/gpio.h |   10 +++++-----

OK but grrrr!

What needs to happen to the s3c24xx is to get rid of this file.

- Define ARCH_NR_GPIOS in arch/arm/Kconfig entry
  ARCH_NR_GPIO like everyone else

- Get rid of the config symbol NEED_MACH_GPIO_H

-  Move this file down into arch/arm/mach-s3c24xx/s3c24xx-gpio.h
  or whatever and make it local...

I will try to do this myself if noone else helps out, so I'd like to
carry this patch in the GPIO tree provided I can get an ACK from
the S3C24xx maintainer. Tomasz, is that you or Kukjin?

(BTW the above maybe goes for S3c64xx as well .. and S5P
oh well I will get to it.)

Yours,
Linus Walleij
