Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3LKFlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:41:36 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61979 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3LKFlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:41:35 -0500
Message-ID: <1386740489.7152.288.camel@host5.omatika.ru>
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Mack <zonque@gmail.com>, Olof Johansson <olof@lixom.net>,
        Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 11 Dec 2013 09:41:29 +0400
In-Reply-To: <201312110611.46443.arnd@arndb.de>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <201312102257.33942.arnd@arndb.de>
	 <1386736215.7152.259.camel@host5.omatika.ru>
	 <201312110611.46443.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 06:11 +0100, Arnd Bergmann wrote:
> It depends: if the driver is for the entire FPGA and does
> the irqchip stuff in addition, it should probably live
> in drivers/mfd. If it's a pure irqchip driver, drivers/irqchip
> is better. You have to be careful in the second case though
> because devices pointing to this irqchip in DT won't get
> an IRQ resource assigned automatically but have to use
> irq_of_parse_and_map instead. This may have been fixed since
> I last looked though, I would consider that behavior a
> bug in the of_platform handling.

Thanks again for explaining.

Although FPGA is a MFD, its irq are used mostly by 8250 serial ports. It
will be enough to embed irqchip into serial driver for now.

If there is a need to use the chip in another driver, it will be
possible to introduce an artificial dependency there for the serial
driver to ensure the serial driver is loaded before the other one.

Is this plan acceptable?

