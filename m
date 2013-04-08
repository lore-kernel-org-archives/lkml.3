Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935780Ab3DHTiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:38:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935727Ab3DHTiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:38:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Fabian Vogt" <fabian@ritter-vogt.de>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
Date: Mon, 8 Apr 2013 21:38:15 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Daniel Tang" <dt.tangr@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, "Lionel Debroux" <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org,
        "Linus Walleij" <linus.walleij@linaro.org>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <896CB251-17FC-4327-BA4E-A8FD9ED1BEC7@gmail.com> <op.wu8k5pwqu7prd4@fabians-laptop.fritz.box>
In-Reply-To: <op.wu8k5pwqu7prd4@fabians-laptop.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304082138.15875.arnd@arndb.de>
X-Provags-ID: V02:K0:LX2YPSqb6p6FXbXAL/CIr+qC9TngM0l9rOZlOvTtfkA
 b4Pmlok17E59eQDOTsdNcOqC+ptudRWbGv3toK+v9mVHCAH0ls
 YMuZ3093GVPjaCgZOW400vgWX5KEHXADn97gT9lSPcBFVul7sr
 RPLPVpD1X0kl0KOVSeesDXUkpYjjxDhZUWZ21vP4masUFw14AP
 WR6RfdBYQAntMtKMQczGMUQ/6WsMZqcsuoV6kud4D2Emprt2TC
 R8hgVOpXdSXXDoSleWFT/uZi4VIkYutJSBK+hFgCL36rKhF9Rj
 Q7S7ST7yAWzeaw7Z59ViL9jS5HA5Lsxu6xo6Ex152/ZG5pZhgC
 QCsUhazVRe0fskScYHjQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013, Fabian Vogt wrote:
> The latest kernel it seems to get stuck at
> console_lock() in register_framebuffer (drivers/video/fbmem.c:1655)
> if the LCD-controller is enabled. (Early printk and serial console works  
> fine)
> CONFIG_NO_HZ is not activated, it works completely.
> Could this be a kernel bug or is this an issue with our timer  
> configuration?

This usually happens when the console driver or anything it uses
calls a function that does a printk(), which means you get a recursive
call into the console code and try to get the same lock again.

	Arnd
