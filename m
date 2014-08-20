Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaHTGDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:03:31 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:33415 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHTGDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:03:30 -0400
Date: Wed, 20 Aug 2014 08:03:04 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 02/12] avr32: at32ap700x: don't rely on default DMA
 masters
Message-ID: <20140820060304.GA20366@samfundet.no>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408469363-15901-3-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408469363-15901-3-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 19 Aug 2014 20:29:13 +0300 or thereabout, Andy Shevchenko wrote:
> In future we are going to remove the defaults of AHB masters from dw_dmac
> driver. It means each user have to supply proper source and destination masters
> by itself explicitly.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/mach-at32ap/at32ap700x.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index 2a1aa71..ec7be28 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -1360,6 +1360,8 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
>  				| DWC_CFGH_DST_PER(1));
>  	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
>  				| DWC_CFGL_HS_SRC_POL);
> +	slave->sdata.src_master = 1;
> +	slave->sdata.dst_master = 0;
>  
>  	data->dma_slave = slave;
-- 
Hans-Christian Egtvedt
