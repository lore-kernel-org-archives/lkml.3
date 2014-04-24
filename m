Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaDXMvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:51:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:51425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaDXMvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:51:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter Griffin <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH 03/13] video: clarify I2C dependencies
Date: Thu, 24 Apr 2014 14:48:26 +0200
Message-ID: <12886728.o7TzRXlxjF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140424123235.GS26756@n2100.arm.linux.org.uk>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org> <1398342509-10243-4-git-send-email-peter.griffin@linaro.org> <20140424123235.GS26756@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tBMXDSUFmd8wSxtVA/j1ohUbD8SG+AW1iQvDM3KtU1d
 V+ie+weLuR7hcGDy/BTQDtQ+jNiMoV8NQhKDATLpPIx+wmp7kX
 rY4e4jr7wPAIBQwIr4Gti8mIpeiXJy+jV3DUWv63iZlKmvs6dx
 kTnguqbXhgTAfUmfgom6OQLnNBQPDb388wEH/YGQqsb1h+Rfuz
 oe/pmmk2n+sh5EpEowGF71pfNjzRyWebLJDvMErKgpNj40Jj+m
 Ic3v0e+gMs4hazpguFhkJQQrZDACKnSHppZQm7CTDNgTMaWDcq
 CmmHGUyNY7n28gIfHPa6DkDRpW35/EyV51MQB20xq+qgdgi1FX
 1KBKoaCJGftyQrf71lGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2014 13:32:35 Russell King - ARM Linux wrote:
> On Thu, Apr 24, 2014 at 01:28:19PM +0100, Peter Griffin wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > We can only use I2C support in frame buffer drivers if
> > Either I2C is built-in, or both I2C and the driver itself
> > are loadable modules.
> 
> Why?


If I2C is a loadable module, and the I2C support of the framebuffer
driver is built-in, you get a link error when building vmlinux:

drivers/built-in.o: In function `cyberpro_pci_remove':
:(.text+0x1ea5c): undefined reference to `i2c_del_adapter'
drivers/built-in.o: In function `cyberpro_pci_probe':
:(.text+0x20224): undefined reference to `i2c_bit_add_bus'
:(.text+0x20240): undefined reference to `i2c_del_adapter'
make[2]: *** [vmlinux] Error 1

It's probably a good idea to mention that in the changeset
text.

	Arnd
