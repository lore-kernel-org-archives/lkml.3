Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaCVLw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:52:26 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53142 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaCVLwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:52:22 -0400
Message-ID: <532D79B5.5000804@kernel.org>
Date: Sat, 22 Mar 2014 11:53:25 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jimmy Li <coder.liss@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix a missing break in devivers/staging/iio
References: <20140322055858.GA11734@gmail.com>
In-Reply-To: <20140322055858.GA11734@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/14 05:58, Jimmy Li wrote:
> fix a missing break.
>
> Signed-off-by: Jimmy Li <coder.liss@gmail.com>
Thanks. I reworded the patch title to match with convention we have ended
up with for iio patches and applied to the fixes-togreg branch of iio.git

This will go in shortly after the first rc.

Jonathan
> ---
>   drivers/staging/iio/resolver/ad2s1200.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
> index 36eedd8..e2b4820 100644
> --- a/drivers/staging/iio/resolver/ad2s1200.c
> +++ b/drivers/staging/iio/resolver/ad2s1200.c
> @@ -70,6 +70,7 @@ static int ad2s1200_read_raw(struct iio_dev *indio_dev,
>   		vel = (((s16)(st->rx[0])) << 4) | ((st->rx[1] & 0xF0) >> 4);
>   		vel = (vel << 4) >> 4;
>   		*val = vel;
> +		break;
>   	default:
>   		mutex_unlock(&st->lock);
>   		return -EINVAL;
>

