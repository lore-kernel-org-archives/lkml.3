Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaKJRH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:07:26 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33596 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbaKJRHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:07:23 -0500
Message-ID: <5460EF02.3000904@gmail.com>
Date: Mon, 10 Nov 2014 18:59:46 +0200
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        eric.piel@tremplin-utc.net, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: randconfig build error with next-20141110, in drivers/platform/x86/hp_accel.c
References: <CA+r1Zhio+KeBH0FFHwj=_fTFjqzebeE7Y2O_vsvMco49Sp56jw@mail.gmail.com>
In-Reply-To: <CA+r1Zhio+KeBH0FFHwj=_fTFjqzebeE7Y2O_vsvMco49Sp56jw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On 2014.11.10 18:20, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `lis3lv02d_remove':
> /home/jim/linux/drivers/platform/x86/hp_accel.c:389: undefined
> reference to `i8042_remove_filter'
> drivers/built-in.o: In function `lis3lv02d_add':
> /home/jim/linux/drivers/platform/x86/hp_accel.c:370: undefined
> reference to `i8042_install_filter'
> make: *** [vmlinux] Error 1
> 

Oops, sorry. Forgot to add a depend on i8042 per this patch in Kconfig:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=a4c724d0723b078e4ab4670e557cda1795036a7a

This patch should fix it. After applying and using your .config I
compiled the kernel without those undefined references. Should I make a
new thread where it's submitted in the proper form? 

thanks,
Giedrius
---
 drivers/platform/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 4dcfb71..7d146e68 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -202,6 +202,7 @@ config TC1100_WMI
 config HP_ACCEL
 	tristate "HP laptop accelerometer"
 	depends on INPUT && ACPI
+        depends on SERIO_I8042
 	select SENSORS_LIS3LV02D
 	select NEW_LEDS
 	select LEDS_CLASS
-- 
2.1.3

