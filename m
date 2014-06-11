Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaFKItG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:49:06 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65440 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaFKItB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:49:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        linux-i2c@vger.kernel.org, Shuge <shuge@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        kevin@allwinnertech.com
Subject: Re: [PATCH v6 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface) controller support
Date: Wed, 11 Jun 2014 10:47:57 +0200
Message-ID: <4433415.Jcexj2E6Ru@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1402475980-15513-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1402475980-15513-1-git-send-email-boris.brezillon@free-electrons.com> <1402475980-15513-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GIPb+jzAp6sn137XnM1uVCC0lDeclkHywGEkX7+Rycs
 kK5xt3JKRukW2181PahP5/9+kMbDyOUJcRlz6Z9liSG+UcMBX0
 5cTHGIMcLPRgW1Bm4zNtgIJKMtVPtwZuoP1AZPsHT9tBseYI3o
 m+VA2HFZD75R34gxLiWVp2QSUv/0eFrriG4CXJm1kzSdjVy26D
 gzdaixq0fdjOHVM7q20uHOA9QrmVX24Cy9PRzkJ3kgt7MkgkHH
 ygtV8xXH6IXNvU8Ab4h9VSoc0cPstjM2Hqzz36djIq2s7759kY
 7agU/trzcMGljMFKrqioVvxo+yBV/51aE4Xf/3MLO8LZOx7jyS
 0wvWDAAnx3LWQjgYKFzU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2014 10:39:40 Boris BREZILLON wrote:
> The P2WI controller looks like an SMBus controller which only supports byte
> data transfers. But, it differs from standard SMBus protocol on several
> aspects:
> - it supports only one slave device, and thus drop the address field
> - it adds a parity bit every 8bits of data
> - only one read access is required to read a byte (instead of a write
>   followed by a read access in standard SMBus protocol)
> - there's no Ack bit after each byte transfer
> 
> This means this bus cannot be used to interface with standard SMBus
> devices (the only known device to support this interface is the AXP221
> PMIC).
> However the P2WI protocol is close enough to SMBus to be integrated in
> the I2C subsystem (see this thread [1] for detailed reasons that led to
> integrating this driver in the I2C subsystem).
> 
> [1] http://www.spinics.net/lists/linux-i2c/msg15066.html
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index c94db1c..a6023fe 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -771,6 +771,18 @@ config I2C_STU300
>           This driver can also be built as a module. If so, the module
>           will be called i2c-stu300.
>  
> +config I2C_SUN6I_P2WI
> +       tristate "Allwinner sun6i internal P2WI controller"
> +       depends on MACH_SUN6I && RESET_CONTROLLER

One very minor comment: I wonder if we should make this 

	depends on RESET_CONTROLLER
	depends on MACH_SUN6I || COMPILE_TEST

instead so we have better build coverage. I haven't tested if building
on other architectures works, or if there are additional dependencies.

No need to change this if there are no other comments.

	Arnd
