Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaEHNmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:42:33 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63899 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaEHNmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:42:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio: include linux/bug.h in interface header
Date: Thu, 08 May 2014 15:42:25 +0200
Message-ID: <7225229.HqAtN0I8Si@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nu3Npq22Cm9sH6zegpug6R+sP0NPjOUJMvWX1GoZ8Sx
 C3qvtZwMscKGjQ0jakuFnEisQqopW6NudIDJ0krs/jglRROEeW
 2c8lfqcwfLWG+VGs7FA1qwpQOSUmLoDHyOGbQJDIB1xQpdSiSC
 NOxGKbmc0AelrWHEZl6CAAXef9NaC1+zRegIfgzqbZe9G+P2mA
 d2EnCtZOynEC8/8ZQaNB+YTGXYyFHv5g8vY9j/2rV22/JQP2Mv
 xyQyhlH9W8Y3ZMOvcnS2mvAos+9yX+PMZRdfECjuykH4MOPjh2
 PkPtWbSPiBnQFmXG8XQYMOIgZvRjVG/1WsqIQuufTgNT59u5/+
 Iwb5n7d+0xi2QFkIVuUs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next kernel started showing build errors for the
use of WARN_ON in linux/gpio/consumer.h:

In file included from drivers/video/backlight/pwm_bl.c:13:0:
include/linux/gpio/consumer.h: In function 'gpiod_put':
include/linux/gpio/consumer.h:81:2: error: implicit declaration of function 'WARN_ON' [-Werror=implicit-function-declaration]

It's not clear why this never happened before, but this patch
fixes it by including the header that contains the defintion
of this macro.

Signed-off-by: Arnd Bergmann <arnd@arnd.de>

diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index bed128e..073b9b1 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_GPIO_CONSUMER_H
 #define __LINUX_GPIO_CONSUMER_H
 
+#include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 

