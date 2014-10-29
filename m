Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaJ2Gbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:31:41 -0400
Received: from mailgw02.mediatek.com ([218.249.47.111]:50102 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbaJ2Gbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:31:38 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2014 02:31:37 EDT
X-Listener-Flag: 11101
Message-ID: <1414563980.24175.6.camel@mhfsdcap03>
Subject: Re: [PATCH 0/3] ARM: mediatek: Add driver for Mediatek I2C
 controller
From: xudong chen <xudong.chen@mediatek.com>
To: Mark Rutland <mark.rutland@arm.com>, Wolfram Sang <wsa@the-dreams.de>,
        Matthias Brugger <matthias.bgg@gmail.com>, <arm@kernel.org>
CC: <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "Jean Delvare" <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        "Yingjoe Chen" <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Date: Wed, 29 Oct 2014 14:26:20 +0800
In-Reply-To: <1414561058-23803-1-git-send-email-xudong.chen@mediatek.com>
References: <1414561058-23803-1-git-send-email-xudong.chen@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sirs,

Missed the first paragraph, sorry for extra mail.

This series is the first version of Mediatek SoCs I2C controller common
bus driver, it is Request for Comment.
Because the clock driver for mediatek SoC is not ready yet(still work in
progress), so I delete the related clock code in dtsi file for now.

Best Regards,
	Xudong
 
On Wed, 2014-10-29 at 13:37 +0800, Xudong Chen wrote:
> This driver is based on 3.18-rc1 & Hongzhou's gpio patch.
> 
> MTK I2C HW has some limitation.
> 1. If the i2c_msg number is more than one, STOP will be issued instead of
> RS(Repeat Start) between each message.
> Such as: "START + ADDR + DATA_n + STOP + START + ADDR + DATA_n + STOP ..."
> 
> 2. Mediatek I2C controller support WRRD(write then read) mode, in WRRD
> mode the Repeat Start will be issued between 2 messages.
> In this driver if 2 messages is first write then read, the driver will
> combine 2 messages using Write-Read mode so the RS will be issued between
> the 2 messages.
> Ex: W/R/R, driver will combine first W/R and then R.
> The data series will be:
> "START + WriteADDR + DATA + RS + ReadADDR + DATA + STOP + START + ReadADDR +
> DATA + STOP".
> 
> 3. Due to HW limitation, in this version the max transfer data length is 255
> in one message. If want to transfer more than 255 bytes, HW needs the SW
> driver to split the data. Take 600 bytes for example, the data need to be
> divided into 3 parts 255 + 255 + 90. The data series will be:
> "START + ADDR + DATA_255 + RS + ADDR + DATA_255 + RS + ADDR +  DATA_90 + STOP"
> instead of "START + ADDR + DATA_900 + STOP".
> We haven't implement this yet, we will do this in the separate patch.
> 
> MT8135 can control I2C pins on PMIC(MT6397) by setting the i2c registers in
> MT8135 side. In this case, driver should set OFFSET_PATH_DIR bit first, the
> operation on other registers are still the same.
> 
> Xudong Chen (3):
>   dt-bindings: Add I2C bindings for mt65xx/mt81xx.
>   ARM: mediatek: Add I2C node for mt8135 and mt8127
>   I2C: mediatek: Add driver for MediaTek I2C controller
> 
>  .../devicetree/bindings/i2c/i2c-mt6577.txt         |  37 ++
>  arch/arm/boot/dts/mt8127.dtsi                      |  27 +
>  arch/arm/boot/dts/mt8135.dtsi                      |  51 ++
>  drivers/i2c/busses/Kconfig                         |   9 +
>  drivers/i2c/busses/Makefile                        |   1 +
>  drivers/i2c/busses/i2c-mt65xx.c                    | 728 +++++++++++++++++++++
>  6 files changed, 853 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
>  create mode 100644 drivers/i2c/busses/i2c-mt65xx.c
> 
> --
> 1.8.1.1.dirty
> 


