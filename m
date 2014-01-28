Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaA1VFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:05:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbaA1VFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:05:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linus.walleij@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: iop32x: gpio breakage after "instantiate GPIO from platform device"
Date: Tue, 28 Jan 2014 22:05:45 +0100
Message-ID: <4202760.m9CxkiIWk3@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U32PWMvFaLBRAxSjS6SefyBOy+prD+EbpyB8NSnRHmz
 ULpxqGhQT9JRZOEj+1iVHZAUYCnnsz+ev5TWw7wDj1eG+NIv59
 Yxh9yWH5TpRmBTiSZfmDLrAcCr5wEWY/jfLU9jGd5Qs2fX7SXk
 DmX6vntMcJKcZKOhnvq3qVdyi+1FVUfaMT3t5zxl+/TEU+nQQS
 Az0jPso+7t+m3CLaYlpiNuJQyHRYFWJIekEmKPfN84IMe++ydw
 Rc3HAoFbBshXSOqV7up0X3e2tOtiLrZ/rJBc9zvxZTGF/FWvP+
 9fbWhUdV5KU70KUkB9seK8g7vlogTwB5KqzHbYZS+0fbwRyd7g
 SWDKoLotPXPBXnuYXr7c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7b85b867b9904 "ARM: plat-iop: instantiate GPIO from platform
device" nicely cleaned up the gpio register access for iop, but
forgot one board that directly pokes into the gpio registers
to do a system reset.

That board no longer compiles, and this patch just disables
the code in question to work around it so I can locally build
randconfig again, but it needs to be fixed properly.

diff --git a/arch/arm/mach-iop32x/em7210.c b/arch/arm/mach-iop32x/em7210.c
index 177cd07..f3cb8e1 100644
--- a/arch/arm/mach-iop32x/em7210.c
+++ b/arch/arm/mach-iop32x/em7210.c
@@ -178,8 +178,10 @@ static struct platform_device em7210_serial_device = {
 
 void em7210_power_off(void)
 {
+#if 0
 	*IOP3XX_GPOE &= 0xfe;
 	*IOP3XX_GPOD |= 0x01;
+#endif
 }
 
 static void __init em7210_init_machine(void)

