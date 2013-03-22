Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161069Ab3CVQ6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:58:43 -0400
Received: from void.printf.net ([89.145.121.20]:43702 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160998Ab3CVQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:58:41 -0400
From: Chris Ball <cjb@laptop.org>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Johan Hovold <jhovold@gmail.com>, linux-mmc@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH] ARM: at91/avr32/atmel-mci: fix DMA-channel leak on module unload
References: <1363191119-4948-1-git-send-email-jhovold@gmail.com>
	<46568.1708221838$1363345027@news.gmane.org>
Date: Fri, 22 Mar 2013 12:58:35 -0400
In-Reply-To: <46568.1708221838$1363345027@news.gmane.org> (Ludovic Desroches's
	message of "Fri, 15 Mar 2013 11:56:06 +0100")
Message-ID: <87ehf7mkw4.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 15 2013, Ludovic Desroches wrote:
> On Wed, Mar 13, 2013 at 05:11:59PM +0100, Johan Hovold wrote:
>> Fix regression introduced by commit 796211b7953 ("mmc: atmel-mci: add
>> pdc support and runtime capabilities detection") which removed the need
>> for CONFIG_MMC_ATMELMCI_DMA but kept the Kconfig-entry as well as the
>> compile guards around dma_release_channel() in remove(). Consequently,
>> DMA is always enabled (if supported), but the DMA-channel is not
>> released on module unload unless the DMA-config option is selected.
>> 
>> Remove the no longer used CONFIG_MMC_ATMELMCI_DMA option completely.
>> 
>> Cc: stable <stable@vger.kernel.org>
>> Signed-off-by: Johan Hovold <jhovold@gmail.com>
>
> Hi Johan,
>
> Good point so
>
> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Thanks, I'll merge this via the MMC tree if no-one objects.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
