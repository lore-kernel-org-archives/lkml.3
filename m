Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaCVQQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:16:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:55397 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaCVQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:16:52 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: atull@altera.com
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        delicious.quinoa@gmail.com
Subject: dwapb: a bug fix a few cleanups, v2
Date: Sat, 22 Mar 2014 17:16:37 +0100
Message-Id: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Alan said that he had drop two patches from earlier series to make
it work I decided to spent some extra time to check if this is really the
case.
I dropped "gpio: dwapb: do not create the irq mapping upfront." until the
discussion there is over.

This series has been tested back ported and tested on a v3.13 kernel with
the dummy test [0] here. It was tested on the Arrow board and the dev kit. I
tested edge and level interrupts. On the Arrow board releasing the button
causes a lot of interrupts so I assume debouncing is no working well
there. On the dev kit I see only one interrupt. If I realse it really
slowly, then the extra interrupts are visible there as well but way less.

[0] http://breakpoint.cc/gpio-dwapb-test.c

Sebastian

