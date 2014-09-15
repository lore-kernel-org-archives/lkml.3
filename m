Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaIOLuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:50:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:46767 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbaIOLuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:50:37 -0400
Message-ID: <5416D26A.4080707@ahsoftware.de>
Date: Mon, 15 Sep 2014 13:50:02 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Robin Gong <b38343@freescale.com>, shawn.guo@freescale.com,
        kernel@pengutronix.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on i.mx6dl
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
In-Reply-To: <1410327012-31185-1-git-send-email-b38343@freescale.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.09.2014 07:30, schrieb Robin Gong:
> There is one weird data in rxfifo after one full rx/tx transfer
> done sometimes. It looks a design issue and hard to workaround
> totally, so disable dma functhion here. And will re-enable it
> once the root cause found.

Hmm, I experience problems with DMA too but on uart3. I'm using the same
workaround for the uart (I've just commented out the dma entries in the DT).
The problem manifests itself here such, that brcm_patchram_plus hangs 
while uploading the firmware to a BCM4330 connected at uart3 (reproducible).

So maybe there is a bug in the DMA-engine which not only effects SPI. Or 
both drivers contain the same error in handling DMA (maybe through c&p).
But that's just specualtion from me, I haven't looked further into that 
problem.

Regards,

Alexander Holler
