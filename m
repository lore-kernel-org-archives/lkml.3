Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965768Ab3GSKg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:36:59 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2617 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965356Ab3GSKg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:36:57 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <51E916C0.8080206@broadcom.com>
Date: Fri, 19 Jul 2013 12:36:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Tony Lindgren" <tony@atomide.com>
cc: linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Roger Quadros" <rogerq@ti.com>
Subject: Re: Regression 3.11-rc1: omap4panda: no usb and consequently no
 ethernet
References: <51E7AA24.6080600@broadcom.com>
 <20130718085951.GT7656@atomide.com>
In-Reply-To: <20130718085951.GT7656@atomide.com>
X-WSS-ID: 7DF7CAD11R045924264-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 10:59 AM, Tony Lindgren wrote:
> Then for the SDIO with device tree, take a look at the following
> patches:
>
> [PATCH 0/3] WLAN support for omap4 when booted with devicetree
> http://comments.gmane.org/gmane.linux.ports.arm.omap/97522#

I have been looking at the pandaboard patch in the series above and I do 
have a question. Among other things the patch adds these dt entries.

+			0x108 0x118	/* sdmmc5_clk.sdmmc5_clk INPUT_PULLUP | MODE0 */
+			0x10a 0x118	/* sdmmc5_cmd.sdmmc5_cmd INPUT_PULLUP | MODE0 */

If I look at the similar names in the deceased board-omap4panda.c:

board-omap4panda.c:	OMAP4_MUX(SDMMC5_CMD, OMAP_MUX_MODE0 | 
OMAP_PIN_INPUT_PULLUP),
board-omap4panda.c:	OMAP4_MUX(SDMMC5_CLK, OMAP_MUX_MODE0 | 
OMAP_PIN_INPUT_PULLUP),

and in mux44xx.h:

mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CLK_OFFSET	0x0148
mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CMD_OFFSET	0x014a

So how did 0x0148 get 0x0108 in DT and 0x014a get 0x010a. There is 
probably an explanation to it and it would help my understanding to know 
where this difference comes from. Hope you can help me out here.

Below are the definitions that I need to move into a dts.

Regards,
Arend

	/* MMC2 Mux for extension board */
	/* MMC2 CMD */
	OMAP4_MUX(GPMC_NWE, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
	/* MMC2 CLK */
	OMAP4_MUX(GPMC_NOE, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
	/* MMC2 DAT 0-7 */
	OMAP4_MUX(GPMC_AD0, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
	OMAP4_MUX(GPMC_AD1, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
	OMAP4_MUX(GPMC_AD2, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
	OMAP4_MUX(GPMC_AD3, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),

