Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3BDVsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:48:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3BDVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:48:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
Date: Mon, 4 Feb 2013 21:47:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Cyril Chemparathy <cyril@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, balbi@ti.com,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, "Nair, Sandeep" <sandeep_n@ti.com>,
        Chris Ball <cjb@laptop.org>, Matt Porter <mporter@ti.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
References: <510C2A47.1090607@mvista.com> <20130204203358.GX4720@opensource.wolfsonmicro.com> <CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com>
In-Reply-To: <CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302042147.38407.arnd@arndb.de>
X-Provags-ID: V02:K0:Or3zkanQJNu3v103eKzZpnRe+oD/YIFCeIZ7lsUkSV8
 FVFxsKlefYnwvCm5+TJxXQfsUYXBOe4rRYTXJ86AiEfPWgunS9
 Ofyrj6dGLQc/itjyJnxx9j7REeeIfZfyd/65U93qhZD/SnfdRH
 Ovfeo9eqj/JHV3rtQX3MoTaEspEpbgQZ5cwePtZASsCksvRWwP
 P2YUMOSRnO8gpAkvvnyGXKf6M90Icqi7LR93InJrNbtTddSWil
 wT8o0M+C26izG5RPNkpPhUDP4CUap38pcdTwEkc6TnrAIdutaL
 JzJ432FNw4T5CfllAwY3ROueZiNUPQgQ7MCLSyW2hdz/3DRMN5
 1q0ve9lS/e1U4vyMob9Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2013, Linus Walleij wrote:
> So I think the above concerns are moot. The callback we can
> set on cookies is entirely optional, and it's even implemented by
> each DMA engine, and some may not even support it but require
> polling, and then it won't even be implemented by the driver.

Just to ensure that everybody is talking about the same thing here:
Is it just the callback that is optional, or also the interrupt
coming from the hardware? With NAPI, you want to avoid both, since
getting an interrupt for every packet adds noticeable overhead,
but you still want to be able to tell the hardware that you
are fed up with polling and would like to get an interrupt again
when the next data arrives (ideally, after either a little time
has passed after the next packet, or a specific number of packets
has arrived).

	Arnd
