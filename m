Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaIPJmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:42:18 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49522 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaIPJmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:42:15 -0400
Message-ID: <541805E3.6080003@ahsoftware.de>
Date: Tue, 16 Sep 2014 11:41:55 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Robin Gong <b38343@freescale.com>
CC: shawn.guo@freescale.com, kernel@pengutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        fugang.duan@freescale.com
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on i.mx6dl
References: <1410327012-31185-1-git-send-email-b38343@freescale.com> <5416D26A.4080707@ahsoftware.de> <20140916035204.GB20800@Robin-OptiPlex-780>
In-Reply-To: <20140916035204.GB20800@Robin-OptiPlex-780>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.09.2014 05:52, schrieb Robin Gong:
> On Mon, Sep 15, 2014 at 01:50:02PM +0200, Alexander Holler wrote:
>> Am 10.09.2014 07:30, schrieb Robin Gong:
>>> There is one weird data in rxfifo after one full rx/tx transfer
>>> done sometimes. It looks a design issue and hard to workaround
>>> totally, so disable dma functhion here. And will re-enable it
>>> once the root cause found.
>>
>> Hmm, I experience problems with DMA too but on uart3. I'm using the same
>> workaround for the uart (I've just commented out the dma entries in the DT).
>> The problem manifests itself here such, that brcm_patchram_plus
>> hangs while uploading the firmware to a BCM4330 connected at uart3
>> (reproducible).
>>
>> So maybe there is a bug in the DMA-engine which not only effects
>> SPI. Or both drivers contain the same error in handling DMA (maybe
>> through c&p).
>> But that's just specualtion from me, I haven't looked further into
>> that problem.
>>
>> Regards,
>>
>> Alexander Holler
> Thanks for your information share. But my issue should be caused by hardware,
> since everything is ok if it runs on other i.mx6 chip. Is your board also based
> on i.mx6 chip? If yes, hope you can raise your issue in freescale community or
> contact with Andy whose mail address added in CC list fugang.duan@freescale.cm.
> We have fix some bugs in UART DMA case.

It's an i.mx6q (Wandboard quad c1) where I have this problem with 
mainline and much older (but heavily patched freescale 3.10.x based) 
kernels. A quick web-search suggests that this problem exists since a 
long time (noticed mainly by people which try to use BT as this seems to 
be the major use case for high speed serial communication).

Regards,

Alexander Holler
