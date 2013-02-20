Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031Ab3BTHdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:33:41 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36553 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969Ab3BTHdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:33:40 -0500
Date: Tue, 19 Feb 2013 23:33:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] mfd: ezx-pcap: use devm_request_irq() and
 devm_kzalloc()
Message-ID: <20130220073337.GC2648@core.coreip.homeip.net>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002d01ce0f31$5940b4b0$0bc21e10$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002d01ce0f31$5940b4b0$0bc21e10$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 03:13:06PM +0900, Jingoo Han wrote:
> Use devm_request_irq() and devm_kzalloc() to make cleanup paths
> more simple.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/ezx-pcap.c |   16 +++++-----------
>  1 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> index b7a61f0..8dea3a9 100644
> --- a/drivers/mfd/ezx-pcap.c
> +++ b/drivers/mfd/ezx-pcap.c
> @@ -403,7 +403,6 @@ static int ezx_pcap_remove(struct spi_device *spi)
>  	/* cleanup ADC */
>  	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
>  				PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE);
> -	free_irq(adc_irq, pcap);
>  	mutex_lock(&pcap->adc_mutex);
>  	for (i = 0; i < PCAP_ADC_MAXQ; i++)
>  		kfree(pcap->adc_queue[i]);
> @@ -415,8 +414,6 @@ static int ezx_pcap_remove(struct spi_device *spi)
>  
>  	destroy_workqueue(pcap->workqueue);
>  
> -	kfree(pcap);
> -

I am pretty sure this conversion is wrong as well. Pretty much
work/workqueue and devm_request_irq() do not mix.

Thanks.

-- 
Dmitry
