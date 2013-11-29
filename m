Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3K2LBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:01:41 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:35398
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab3K2LBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:01:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz17326ah8275dh1de097h186068hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Message-ID: <529874EE.402@freescale.com>
Date: Fri, 29 Nov 2013 19:05:18 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Brian Norris <computersforpeace@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <angus.clark@st.com>, <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 00/23] mtd: st_spi_fsm: Add new device
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org> <20131127040723.GZ9468@ld-irv-0074.broadcom.com> <20131127115226.GC3296@lee--X1> <5296B9C5.3060704@freescale.com> <20131128092904.GZ3296@lee--X1>
In-Reply-To: <20131128092904.GZ3296@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jones & Augus:

thanks for your explanations.
> Most controllers just take an OPCODE and pass it on to the controller
> and have done with it. The issue that you're attempting to rectify is
> that the m25p80 expects every controller to be an SPI controller
> registered to the SPI framework, but as we both know that's not always
> practical as the SPI framework doesn't allow all configuration
> information to be passed back to the controller driver. Our issue is
> not the same. We are required to send entire 'message sequences', to
> the controller rather than just opcodes. The JEDEC message sequence
> can be seen below. Bear in mind that this is also one of the more
> simple message sequences. Some of them even vary depending on which
> chip is present.
Frankly speaking, my quadspi driver's code is just like Jones's code.
Yes, a big "switch".

The opcode is just like an index to trigger the proper operation.
That's why i add this hook @->read_reg(). (the hook acts as the ioctl)

If we do not use this hooks, we should add more hooks such as
@->read_id, @->read_sr, @->read_cr...

That's make the interface not graceful enough.


I read the your patch implementing the read_id:

http://lists.infradead.org/pipermail/linux-mtd/2013-November/050221.html


it's more readable. But i think Jones's stfsm_read_reg() is workable too.


If you do not like the read_reg() hook, do you have any better idea?



thanks
Huang Shijie




