Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaKOQEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 11:04:52 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42797 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbaKOQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 11:04:50 -0500
Message-ID: <546779A0.1040507@kernel.org>
Date: Sat, 15 Nov 2014 16:04:48 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Cristina Ciocan <cristina.ciocan@intel.com>, linux-iio@vger.kernel.org
CC: lars@metafoo.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask
References: <1415714862-5709-1-git-send-email-cristina.ciocan@intel.com>
In-Reply-To: <1415714862-5709-1-git-send-email-cristina.ciocan@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 14:07, Cristina Ciocan wrote:
> The direction field is set on 7 bits, thus we need to AND it with 0111 111 mask
> in order to retrieve it, that is 0x7F, not 0xCF as it is now.
> 
> Fixes: ade7ef7ba (staging:iio: Differential channel handling)
> Signed-off-by: Cristina Ciocan <cristina.ciocan@intel.com>
Applied to the fixes togreg branch of iio,git.

Thanks,

Jonathan
> ---
>  include/linux/iio/events.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/iio/events.h b/include/linux/iio/events.h
> index 8bbd7bc..03fa332 100644
> --- a/include/linux/iio/events.h
> +++ b/include/linux/iio/events.h
> @@ -72,7 +72,7 @@ struct iio_event_data {
> 
>  #define IIO_EVENT_CODE_EXTRACT_TYPE(mask) ((mask >> 56) & 0xFF)
> 
> -#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0xCF)
> +#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0x7F)
> 
>  #define IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(mask) ((mask >> 32) & 0xFF)
> 
> --
> 1.8.1.2
> 

