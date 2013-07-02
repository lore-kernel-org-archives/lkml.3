Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3GBVK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:10:27 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51694 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3GBVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:10:26 -0400
Message-ID: <51D341C0.1060904@kernel.org>
Date: Tue, 02 Jul 2013 22:10:24 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, stable@vger.kernel.org
Subject: Re: [PATCH] iio: Fix iio_channel_has_info
References: <1372688430-13120-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1372688430-13120-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 03:20 PM, Alexandre Belloni wrote:
> Since the info_mask split, iio_channel_has_info() is not working correctly.
> info_mask_separate and info_mask_shared_by_type, it is not possible to compare
> them directly with the iio_chan_info_enum enum. Correct that bit using the BIT()
> macro.
> 
> Cc: <stable@vger.kernel.org> # 3.10.x
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
ouch / oops is about all I can say to this one.  Ideally might have had a note
in the description about what the effect of this bug is (breakage in the inkern interface)

Thanks and applied to the fixes-togreg branch of iio.git


> ---
>  include/linux/iio/iio.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> index 8d171f4..3d35b70 100644
> --- a/include/linux/iio/iio.h
> +++ b/include/linux/iio/iio.h
> @@ -211,8 +211,8 @@ struct iio_chan_spec {
>  static inline bool iio_channel_has_info(const struct iio_chan_spec *chan,
>  	enum iio_chan_info_enum type)
>  {
> -	return (chan->info_mask_separate & type) |
> -	       (chan->info_mask_shared_by_type & type);
> +	return (chan->info_mask_separate & BIT(type)) |
> +	       (chan->info_mask_shared_by_type & BIT(type));
>  }
>  
>  #define IIO_ST(si, rb, sb, sh)						\
> 
