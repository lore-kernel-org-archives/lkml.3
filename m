Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaFJN4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:56:23 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65304 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaFJN4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:56:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface) controller support
Date: Tue, 10 Jun 2014 15:54:56 +0200
Message-ID: <6454089.IP8IFVsofj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1402408036-5235-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com> <1402408036-5235-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IBAPqgjbsIyBQCHMyTdmoEFUX+vfux8YR+gekbCgiqd
 1lSLMqcypQa5tXvVaHx/Loz9nglczg+INorYk7PNGgvNrug2Q4
 jhoGQvln0NUIf9YY5CrdnR9ApZJGM1LtEkpkKGS4hDKE4Sjg+G
 zrAjnsGP93pw8GDDNgcIJGNv+oOUfn+E9GplK2MLH7xfymegGD
 5qBG1uOHwmOaMX8l+IpjmhHd32tqZMKM9pjgGfdSxM0Boubxbe
 vQPZFjf4qcctcTq1jmmdwsWCMg0cJWw8O+X7+Jl+/NmSbGKhPc
 2wk3x5gjYIgyLgLn3iX8wcdDlipnAu7xD8fKEG+Qcya5KjYh4p
 MTcNwDdtjKIzfshPIkk8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2014 15:47:16 Boris BREZILLON wrote:
> 
> +config I2C_SUN6I_P2WI
> +       tristate "Allwinner sun6i internal P2WI controller"
> +       depends on ARCH_SUNXI
> +       help
> +         If you say yes to this option, support will be included for the
> +         P2WI (Push/Pull 2 Wire Interface) controller embedded in some sunxi
> +         SOCs.
> +         The P2WI looks like an SMBus controller (which supports only byte
> +         accesses), except that it only supports one slave device.
> +         This interface is used to connect to specific PMIC devices (like the
> +         AXP221).
> +

Sorry for the stupid question, but why is this an i2c driver if the
hardware protocol is completely different?

I understand that a lot of devices can be driven using either spi or
i2c, and we have two sets of {directories,maintainers,bus_types,...}
for them. Your description sounds like this is a separate option
that isn't any closer to i2c than it is to spi.

Would it perhaps be better to expose it only as a regmap rather than
an i2c host?

	Arnd
