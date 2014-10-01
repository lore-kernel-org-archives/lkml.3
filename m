Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaJAX0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 19:26:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:53543 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaJAX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 19:26:22 -0400
Message-ID: <542C8D93.8090008@infradead.org>
Date: Wed, 01 Oct 2014 16:26:11 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, wsa@the-dreams.de,
        khali@linux-fr.org, Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-i2c@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-can@vger.kernel.org, linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: randconfig build error with next-20141001, in drivers/i2c/algos/i2c-algo-bit.c
References: <CA+r1ZhiL1y9aeLeJjpd_1DtzOG_oyoPg7XsTPJ9G-XY5G2DfCQ@mail.gmail.com>
In-Reply-To: <CA+r1ZhiL1y9aeLeJjpd_1DtzOG_oyoPg7XsTPJ9G-XY5G2DfCQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/14 14:37, Jim Davis wrote:
> Building with the attached random configuration file,

Also:
warning: (CAN_PEAK_PCIEC && SFC && IGB && VIDEO_TW68 && DRM && FB_DDC && FB_VIA) selects I2C_ALGOBIT which has unmet direct dependencies (I2C)

> drivers/i2c/algos/i2c-algo-bit.c: In function ‘i2c_bit_add_bus’:
> drivers/i2c/algos/i2c-algo-bit.c:658:33: error: ‘i2c_add_adapter’
> undeclared (first use in this function)
>   return __i2c_bit_add_bus(adap, i2c_add_adapter);
>                                  ^
> drivers/i2c/algos/i2c-algo-bit.c:658:33: note: each undeclared
> identifier is reported only once for each function it appears in
> drivers/i2c/algos/i2c-algo-bit.c: In function ‘i2c_bit_add_numbered_bus’:
> drivers/i2c/algos/i2c-algo-bit.c:664:33: error:
> ‘i2c_add_numbered_adapter’ undeclared (first use in this function)
>   return __i2c_bit_add_bus(adap, i2c_add_numbered_adapter);
>                                  ^
>   CC      net/openvswitch/actions.o
> drivers/i2c/algos/i2c-algo-bit.c: In function ‘i2c_bit_add_bus’:
> drivers/i2c/algos/i2c-algo-bit.c:659:1: warning: control reaches end of non-void
>  function [-Wreturn-type]
>  }
>  ^
> drivers/i2c/algos/i2c-algo-bit.c: In function ‘i2c_bit_add_numbered_bus’:
> drivers/i2c/algos/i2c-algo-bit.c:665:1: warning: control reaches end of non-void
>  function [-Wreturn-type]
>  }
>  ^
> make[3]: *** [drivers/i2c/algos/i2c-algo-bit.o] Error 1

In drivers/media/pci/tw68/Kconfig, VIDEO_TW68 should depend on I2C in order
to make it safe to select I2C_ALGOBIT.

In drivers/net/can/sja1000/Kconfig, CAN_PEAK_PCIEC should depend on I2C
instead of selecting I2C (and change the help text).


-- 
~Randy
