Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3FLLf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:35:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3FLLfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:35:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
Date: Wed, 12 Jun 2013 13:36:08 +0200
Message-ID: <3071989.BUSYQuLaN0@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130612090202.GM4107@intel.com>
References: <20130612050829.GB4107@intel.com> <CAHp75VdKsMgdZcA72-eJZWV1cyc+Xkskrpr0i_QBMOZtV6tpeg@mail.gmail.com> <20130612090202.GM4107@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/ShcwxVJoxoktIHwru5o5N51FJpX0hxdrbSuaTZ/pRg
 J/kp93DtX4zaeqo/C63QEewyO/b0+pkzn/IGBBq4dur+S3bvNb
 rDR0RUiIrkwTHLrv+4ojO83PeY+iFsUVjNO1VBBxGfrmjaPtVI
 nikYcqr4MIpdeMteJKswPFvOoGP237b7CmzaVM6mbB1t/ZrgHR
 H8uB0/Q6QOrkvc/TJ5Iz8aHWFYXWrnKSd2yjHT069NTi+JHGKM
 4fdvvpJYaUtZlDP1NAxbCQZIbZOwoUVNfiaH8Pw5U/lik4+l3A
 fD2+Qs5HBuzBKwvRA5ba0O3skK9EkBkZxXA8Idul+xUBB2NLJv
 mOPNmC3+vHCoodbWFy0k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013 14:32:02 Vinod Koul wrote:
>  config DW_DMAC
>         tristate "Synopsys DesignWare AHB DMA platform driver"
>         select DW_DMAC_CORE
> +       select DW_DMAC_BIG_ENDIAN_IO if ARCH=AVR32
>         default y if CPU_AT32AP7000
>         help
>           Support the Synopsys DesignWare AHB DMA controller. This

I assume you have not actually tested this on AVR32?

The Kconfig statement above compares the values of CONFIG_ARCH and
CONFIG_AVR32, so it would turn on big-endian mode when both
are disabled (as is normally the case anywhere).

I think what you meant to write is 

	select DW_DMAC_BIG_ENDIAN_IO if AVR32


On Wednesday 12 June 2013 13:22:25 Vinod Koul wrote:

> > I don't know if we will have any platform in future which has such
> > difference in endianess between CPU and DMA IP block.
> you never know what h/w designers would think!

IIRC AVR32 endianess is screwed up in multiple ways and the kernel
actually does some extra byte swapping depending on the platform.
It's possible that the device is actually doing the regular
little-endian I/O there and this is just a workaround from
the other swaps. It's certainly best to leave the current logic
in place, as your patch does.

	Arnd
