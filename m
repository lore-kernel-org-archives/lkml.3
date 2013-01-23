Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab3AWGFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:05:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34537 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab3AWGF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:05:27 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the leds tree
Thread-Topic: linux-next: build failure after merge of the leds tree
Thread-Index: AQHN+R/goQPzMsQGvEu1vV7J8Q1gE5hWZ6CA
Date: Wed, 23 Jan 2013 06:05:17 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1C225@DQHE02.ent.ti.com>
References: <20130123151223.01bb155bb06a2e30446900c2@canb.auug.org.au>
In-Reply-To: <20130123151223.01bb155bb06a2e30446900c2@canb.auug.org.au>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Wednesday, January 23, 2013 1:12 PM
> To: Bryan Wu
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Kim, Milo
> Subject: linux-next: build failure after merge of the leds tree
> 
> Hi Bryan,
> 
> After merging the leds tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/built-in.o: In function `lp55xx_unregister_leds':
> (.text+0x161dab): undefined reference to `led_classdev_unregister'
> 
> Caused by commit 14732b162d34 ("leds-lp55xx: use
> lp55xx_unregister_leds()").
> 
> drivers/built-in.o: In function `lp55xx_init_led':
> leds-lp55xx-common.c:(.text+0x161f23): undefined reference to
> `led_classdev_register'
> leds-lp55xx-common.c:(.text+0x161f9f): undefined reference to
> `led_classdev_unregister'
> 
> Caused by commit b5370ff365fa ("eds-lp55xx: use lp55xx_init_led()
> common function").
> 
> drivers/built-in.o: In function `lp55xx_read':
> (.text+0x1621b3): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `lp55xx_init_device':
> (.text+0x1622f0): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `lp55xx_init_device':
> (.text+0x162331): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `lp55xx_update_bits':
> (.text+0x162492): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `lp55xx_write':
> (.text+0x1624c5): undefined reference to `i2c_smbus_write_byte_data'
> 
> Caused by commit 597eb710be87 ("leds-lp55xx: add new common driver for
> lp5521/5523").
> 
> I have used the leds tree from next-20130122 for today.

Bryan and Stephen,

Sorry for this errors. A patch has been sent.
https://lkml.org/lkml/2013/1/23/14

And I've got few warnings about leds-lp5521/5523 drivers, separate patchset will
be submitted soon.

Best Regards,
Milo
