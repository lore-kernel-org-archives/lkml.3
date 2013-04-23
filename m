Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3DWPOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:14:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab3DWPOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:14:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 06/10] usb: musb: ux500: add device tree probing support
Date: Tue, 23 Apr 2013 17:14:06 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, mian.yousaf.kaukab@stericsson.com,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org> <1366729394-11406-7-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366729394-11406-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304231714.06326.arnd@arndb.de>
X-Provags-ID: V02:K0:TOZiomV5JL2OoZV8uRuYH6VrgVZ3Rv4VXa7q7a+l4tm
 2FrVrm6OliB2LUQQVsVcxV1luieeenYw/pXTG0LC6sGrqKKjee
 9n332RRD+JSq2ayzQ1dSHVQit+RzTRNYZ3rEncWDf9r4II1hQl
 ANlbydZwiIqWwOEfeHwWkSFoyPY+mk6a2twjAphr2nCIK8iVab
 NkFX+cf11MuHwLgkAPv5tlnjrH5oxPPvXMrCR3zOrY3mV4c04g
 60cTzBUCsTdGknk7yK37G8CXTGDopoAXJs/Oaj889KpUm/ZJ98
 rK74itBfVNBqyIfqk/3ObxYhb9B68bpmGXTo8tZdS/zHPItHFH
 zHHHVsmkxwC2QUFjZXLU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Lee Jones wrote:
> +Required properties:
> + - compatible : Should be "stericsson,db8500-musb"
> + - reg        : Offset and length of registers
> + - interrupts : Interrupt; mode, number and trigger
> + - mode       : One of; "host", "otg", or "peripheral"

I think we don't have any precedent for this combination of "mode" property
and contents. You could either try to match ehci-omap.txt and do

 - mode : Should be "3" to represent OTG. "1" signifies HOST and "2"
   represents PERIPHERAL.

Or you match fsl-usb.txt and nvidia,tegra20-ehci.txt, defining

 - dr_mode : dual role mode. Indicates the working mode to
   controllers.  Can be "host", "peripheral", or "otg".  Default to
   "host" if not defined for backward compatibility.

> +Optional properties:
> + - dmas       : A list of dma channels;
> +                dma-controller, event-line, fixed-channel, flags
> + - dma-names  : An ordered list of channel names affiliated to the above

Please list the exact dma-names that are required.

	Arnd
