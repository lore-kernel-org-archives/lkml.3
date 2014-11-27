Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaK0Ovr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:51:47 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:56447 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaK0Ovo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:51:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        vinod.koul@intel.com, linux-mmc@vger.kernel.org, nsekhar@ti.com,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        khilman@deeprootsystems.com, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>, chris@printf.net,
        dmaengine@vger.kernel.org, ulf.hansson@linaro.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: edma: Rename header file for dmaengine filter function definition
Date: Thu, 27 Nov 2014 15:50:46 +0100
Message-ID: <3300340.ou8f7H2hIc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <547733E3.3020408@ti.com>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <8235185.7qUDHu9jso@wuerfel> <547733E3.3020408@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8rNRqCNeZi66arAFDly48KqjgEwNucIJbyQs0dUQMs1
 vUq/UfZf7kqk3gyJv2OHVsAaLyfenR6GyRD6hCng4EUkMY787K
 KKLnT6jsee3LmwaGg+eLIDV0LT/2ddPLBixfdLQxGQXvUs6GqO
 XgkwQqdv1IPyGL68idTkVZ0RcE2AHi42bSYLtB48Kbtm8e6MQU
 KssaCIyQ+OHhwIV2+CdY6A17bF1c3MKe6wKJMM8MTbzf5um2uZ
 sX4WoI4EhqlLCHcnfewkGmDUCjxiTHaQtEXALfRyoEGvzv31ug
 BgiQpa30dyy6s5WYwshL1UiUL/c+M5u8h0EJINDPfw+AEKWc6L
 aYaDBVx/PITZTL0o25Ho=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 16:23:31 Peter Ujfalusi wrote:
> This will only work in case of legacy boot. When booting with DT we do not
> have pdata and after this patch in dt boot we are not going to be able to get
> the DMA resources either.

No, when booting with DT, the filter_fn and data are not used at all,
we get the dma channel by parsing the DT instead.

> I think if we want to do something like this, it has to be done within the
> dmaengine framework. The dma controller's of_dma_filter_info already have
> .filter_fn which could be used by the framework.

No, of_dma_filter_info/of_dma_simple_xlate was a mistake, we should never
have even introduced that. All drivers that rely on this can simply
provide their own xlate function that calls of_dma_get_slave_channel()
or one of the related functions.

edma is particularly trivial, it can just use of_dma_xlate_by_chan_id()
instead of of_dma_simple_xlate, as it looks up the channel by its number.

	Arnd
