Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3JVQdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:33:11 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:43303 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3JVQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:33:08 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/2] misc: atmel_pwm: fix probe dependencies
Date: Tue, 22 Oct 2013 18:32:38 +0200
Message-Id: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two drivers (atmel-pwm-bl and leds-atmel-pwm) currently depend on the
atmel_pwm driver to have bound to any pwm-device before their devices
are probed.

The first patch adds deferred-probing support to the atmel_pwm driver to
handle such dependencies. Note that the atmel-pwm-bl driver in
linux-next supports deferred probing since commit 9d3fde86b ("backlight:
atmel-pwm-bl: fix deferred probe from __init").

Although deferred probing is sufficient to deal with the dependency
problem, relying on deferred probing for the backlight driver is not
desirable as it may cause unnecessary delays before enabling the
backlight at boot. The second patch fixes this by making sure
pwm-devices are probed before any backlight devices.

Johan

Johan Hovold (2):
  misc: atmel_pwm: add deferred-probing support
  misc: atmel_pwm: set initcall level to subsys

 drivers/misc/atmel_pwm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

-- 
1.8.4

