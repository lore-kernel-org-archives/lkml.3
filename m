Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbbAUJ35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:29:57 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:57715 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbbAUJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:29:45 -0500
Date: Wed, 21 Jan 2015 12:29:41 +0300
From: Mike Krinkin <krinkin.m.u@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: gpio-sx150x.c build error
Message-ID: <20150121092941.GA14840@kmu-tp-x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

i failed to build linux-next for 20 Jan, because of the following build error:

drivers/gpio/gpio-sx150x.c:487:17: error: ‘struct gpio_chip’ has no member named ‘of_node’
  chip->gpio_chip.of_node          = client->dev.of_node;
                 ^
drivers/gpio/gpio-sx150x.c:488:17: error: ‘struct gpio_chip’ has no member named ‘of_gpio_n_cells’
  chip->gpio_chip.of_gpio_n_cells  = 2;
                 ^
make[2]: *** [drivers/gpio/gpio-sx150x.o] Error 1
make[1]: *** [drivers/gpio] Error 2
make: *** [drivers] Error 2

This change introduced by Wei Chen commit 04d2264c3bf0 ("gpio: sx150x: add dts
support for sx150x driver"). Maybe `#ifndef CONFIG_OF_GPIO` should be here?

FIY: i don't use this gpio, just happened to notice, and i have disabled this
in my config.
