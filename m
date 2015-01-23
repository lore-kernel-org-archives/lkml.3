Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbbAWKWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:22:04 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53652 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbbAWKVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:21:44 -0500
Message-ID: <1422008501.30730.22.camel@x220>
Subject: gpio: ARCH_MB86S7X?
From: Paul Bolle <pebolle@tiscali.nl>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Andy Green <andy.green@linaro.org>,
        Vincent Yang <Vincent.Yang@tw.fujitsu.com>,
        Tetsuya Nuriya <nuriya.tetsuya@jp.fujitsu.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Jan 2015 11:21:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2015 10:21:41.0629 (UTC) FILETIME=[6150E2D0:01D036F6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jassi,

Your commit 0da094d82c27 ("gpio: Add Fujitsu MB86S7x GPIO driver") is
included in today's linux-next (ie, next-20150123). I noticed because a
script I use to check linux-next spotted a problem in it.

That commit added the Kconfig symbol GPIO_MB86S7X and made it depend on
ARCH_MB86S7X. But there's no Kconfig symbol ARCH_MB86S7X in linux-next.
I assume a patch to add that symbol is queued somewhere. Is that
correct?

Please note that I actually managed to cross-compile
drivers/gpio/gpio-mb86s7x.c with this command:
    make ARCH=arm CROSS_COMPILE=arm-linux-gnu- EXTRA_CFLAGS="-DCONFIG_GPIOLIB=y" drivers/gpio/gpio-mb86s7x.o

So, for what it's worth, that dependency appears to be not needed to
build this driver.

Thanks,


Paul Bolle

