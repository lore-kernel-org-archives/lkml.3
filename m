Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935909Ab3DHUFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:05:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935880Ab3DHUFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:05:19 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Daniel Tang" <dt.tangr@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, "Lionel Debroux" <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org,
        "Linus Walleij" <linus.walleij@linaro.org>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com>
 <896CB251-17FC-4327-BA4E-A8FD9ED1BEC7@gmail.com>
 <op.wu8k5pwqu7prd4@fabians-laptop.fritz.box>
 <201304082138.15875.arnd@arndb.de>
Date: Mon, 08 Apr 2013 22:06:29 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Fabian Vogt" <fabian@ritter-vogt.de>
Message-ID: <op.wu8ng3wyu7prd4@fabians-laptop.fritz.box>
In-Reply-To: <201304082138.15875.arnd@arndb.de>
User-Agent: Opera Mail/12.14 (Linux)
X-Provags-ID: V02:K0:mVj3wgs5GPXV+2BA0GGCkI3t//BctU2yWcuIuIrB8Vb
 2jrhs1zgZoM+3fHXVGGIv/8MrHKFrCyQefJ6+tM0IkD9+zn5Qz
 E4qV5tCNUwnryb4/IvVSjKPWghAFOS3xmsTEOsJShmj/hmgPzK
 skcAVmNPA0ztX9alEz4TWnXpNJiR0yoxu1FviYdzD+RGWGVnp9
 FhhInNyzpUsgp0Jjk5vCqmjWoZmmKjGkx4P0nrp+mTwrYcl/qa
 JactqrkykiaX/5XBEp8X8OKFYDLZKD8xtSxEPgxyXEW4ly0YId
 0E9ugox6J3eu7MqmzXLu3Zkm5LPzJy5RrmxDOUex7WoN4MM/hu
 8I+nGxTW+z6q65H0tQhek3SKDwhtFB2GOw03/mOwsyX3bhLzpx
 dCnkYGVTb/XHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday 08 April 2013, Fabian Vogt wrote:
>> The latest kernel it seems to get stuck at
>> console_lock() in do_register_framebuffer (drivers/video/fbmem.c:1655)
>> if the LCD-controller is enabled. (Early printk and serial console works
>> fine)
>> CONFIG_NO_HZ is not activated, it works completely.
>> Could this be a kernel bug or is this an issue with our timer
>> configuration?
>
> This usually happens when the console driver or anything it uses
> calls a function that does a printk(), which means you get a recursive
> call into the console code and try to get the same lock again.
Yes, I've heard that before, but than it would work/not work independently
of NO_HZ. Can printk's be executet within console_lock() ..  
console_unlock() blocks?
If not, it could be fb_notifier_call_chain, too, but that wouldn't be  
likely at all.
I also tried spinlock/mutex debugging and soft lockup detection,
but neither of them outputs anything.
