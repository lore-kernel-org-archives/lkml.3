Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaG1KFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:05:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaG1KFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:05:40 -0400
Date: Mon, 28 Jul 2014 11:05:30 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jan Kardell <jan.kardell@telliq.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jonathan Cameron <jic23@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] iio: ti_am335x_adc: Fix prerequisite for stepid patch
Message-ID: <20140728100530.GB5068@hercules>
References: <1406195177-8656-113-git-send-email-luis.henriques@canonical.com>
 <1406286826-30834-1-git-send-email-jan.kardell@telliq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406286826-30834-1-git-send-email-jan.kardell@telliq.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 01:13:46PM +0200, Jan Kardell wrote:
> Kernel series 3.11 and 3.12 does not initialize scan_index in the
> iio_chan_spec structure as 3.13 and newer does. This is necessary
> for the stepid patch to work, otherwise it even breaks the cases
> that worked before the stepid patch.
> 
> Unfortunately the stepid patch seems to already be in 3.12.25,
> must have missed that inclusion.
> 
> Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
> ---
>  drivers/iio/adc/ti_am335x_adc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 3ceac3e..6c56418 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -120,6 +120,7 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
>  		chan->channel = adc_dev->channel_line[i];
>  		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
>  		chan->datasheet_name = chan_name_ain[chan->channel];
> +		chan->scan_index = i;
>  		chan->scan_type.sign = 'u';
>  		chan->scan_type.realbits = 12;
>  		chan->scan_type.storagebits = 32;
> -- 
> 1.8.4.5
> 

Ah, nice catch!

Ideally, I would pick commit ca9a563805f7ae821e3303b1bdbc65d3a3c783ff
("iio: ti_am335x_adc: Add continuous sampling support"), which adds
this scan_index initialisation.  However, this commit doesn't seem be
suitable for a stable kernel, so I'll add this patch to the 3.11.10.14
queue branch.  Thanks a lot, Jan.

Cheers,
--
Luís
