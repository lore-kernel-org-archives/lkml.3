Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267Ab3GSKtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:49:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54177 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760229Ab3GSKtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:49:50 -0400
Message-ID: <51E919CA.8060805@ti.com>
Date: Fri, 19 Jul 2013 13:49:46 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression 3.11-rc1: omap4panda: no usb and consequently no ethernet
References: <51E7AA24.6080600@broadcom.com> <20130718085951.GT7656@atomide.com> <51E916C0.8080206@broadcom.com>
In-Reply-To: <51E916C0.8080206@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 01:36 PM, Arend van Spriel wrote:
> On 07/18/2013 10:59 AM, Tony Lindgren wrote:
>> Then for the SDIO with device tree, take a look at the following
>> patches:
>>
>> [PATCH 0/3] WLAN support for omap4 when booted with devicetree
>> http://comments.gmane.org/gmane.linux.ports.arm.omap/97522#
> 
> I have been looking at the pandaboard patch in the series above and I do have a question. Among other things the patch adds these dt entries.
> 
> +            0x108 0x118    /* sdmmc5_clk.sdmmc5_clk INPUT_PULLUP | MODE0 */
> +            0x10a 0x118    /* sdmmc5_cmd.sdmmc5_cmd INPUT_PULLUP | MODE0 */
> 
> If I look at the similar names in the deceased board-omap4panda.c:
> 
> board-omap4panda.c:    OMAP4_MUX(SDMMC5_CMD, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
> board-omap4panda.c:    OMAP4_MUX(SDMMC5_CLK, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
> 
> and in mux44xx.h:
> 
> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CLK_OFFSET    0x0148
> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CMD_OFFSET    0x014a
> 
> So how did 0x0148 get 0x0108 in DT and 0x014a get 0x010a. There is probably an explanation to it and it would help my understanding to know where this difference comes from. Hope you can help me out here.
> 

If you see omap4.dtsi, omap4_pmx_core starts at register address 0x4a100040.

So, you need to subtract 0x40 from the offsets defined in mux44xx.h for pmx_core registers.

NOTE: omap4_pmx_wkup starts at a different address. Those are for wakeup domain
control registers.

cheers,
-roger

