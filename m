Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbaGQLex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:34:53 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58594 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbaGQLev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:34:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Chen <peter.chen@freescale.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Thu, 17 Jul 2014 13:34:38 +0200
Message-ID: <14435027.UvktXyQjy4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140717111912.GA16025@shlinux1.ap.freescale.net>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com> <5456516.0fVZeXjF8k@wuerfel> <20140717111912.GA16025@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+axIy9ukQUHE7iAz/NNi3U9U9nQXcMDzfrB4rrq7OFx
 WoZ5OJ2OuF/6lmLNfla4zONkfiQW8rvhrCS2VGxAqwdMK9Xwof
 qS34O1tb9ETdMGGOE0h690xUJHVCUu6SME/Sjd2u12p1IDJjL3
 FudYMUFFaI7Ie946zuoSIq5dqjf9ezLt0b9rJsKW3SEtU2fmUg
 de0pM/pO3pfjXEDIRmfwrHFG7XAd5FFF1+uPwpoR1p/L4yamwz
 edIA2fZAZqsH2GMQdQSGhdoJMgIiq8Ayb8aBLNdTeat7+9Sp3Y
 nEzdWelkoolYutfqRweOx9ctcdvb1RYY+2ma1+a1BY1k1nWPjy
 kEaoOSxgcOW/nXp5doCw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2014 19:19:15 Peter Chen wrote:
> 
> Currently, we are designing a generic driver, we don't know what's the
> hardware architecture, we are trying to find a solution how to set
> dma mask for all possible devices which will use this driver, Antoine's
> this patch is trying to cover this feature.
> 
> For example, 
> 
> Marvell Berlin doesn't need to set dma mask specific.
> http://marc.info/?l=linux-arm-kernel&m=140205228507045&w=2
> http://www.spinics.net/lists/linux-usb/msg110598.html
> 
> Xilinx zynq needs to set dma mask as 0xFFFFFFF0
> http://marc.info/?l=linux-usb&m=140384129921706&w=2
> 
> FSL i.mx needs to set dma mask as DMA_BIT_MASK(32)
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/tree/drivers/usb/chipidea/ci_hdrc_imx.c?h=usb-next

Ok, I see now. I think we can safely drop it completely then:

- Berlin was only recently added and doesn't need to set the
  mask because the common code handles it just fine now.

- i.mx was added earlier, at a time where it was still necessary

- zynq just made a mistake, 0xFFFFFFF0 was never a valid mask
  and just happened to work by accident.

In summary, the 32-bit default mask will work on all of them,
and we need no special code or DT properties for it.

	Arnd
