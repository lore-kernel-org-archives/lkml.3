Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbbAUUWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:22:32 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45304 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbAUUWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:22:22 -0500
Message-ID: <54C00A79.5040104@kernel.org>
Date: Wed, 21 Jan 2015 20:22:17 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Asaf Vertz <asaf.vertz@tandemg.com>, gregkh@linuxfoundation.org
CC: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        daniel.baluta@intel.com, roberta.dobrescu@gmail.com,
        paulmck@linux.vnet.ibm.com, mario.schuknecht@dresearch-fe.de,
        aybuke.147@gmail.com, tinajohnson.1234@gmail.com,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: tsl2x7x_core: fix format string warnings
References: <20150120092758.GA4321@ubuntu>
In-Reply-To: <20150120092758.GA4321@ubuntu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 09:27, Asaf Vertz wrote:
> Fixed the following warnings (reported by cppcheck):
> [drivers/staging/iio/light/tsl2x7x_core.c:1150]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/staging/iio/light/tsl2x7x_core.c:1150]: (warning) %d in format string (no. 2)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/staging/iio/light/tsl2x7x_core.c:1150]: (warning) %d in format string (no. 3)
> requires 'int' but the argument type is 'unsigned int'.
> 
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
Applied to the togreg branch of iio.git.  Initially pushed out as
testing for the autobuilders to play.

Thanks,

Jonathan
> ---
>  drivers/staging/iio/light/tsl2x7x_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
> index 423f96b..4a5dc26 100644
> --- a/drivers/staging/iio/light/tsl2x7x_core.c
> +++ b/drivers/staging/iio/light/tsl2x7x_core.c
> @@ -1147,7 +1147,7 @@ static ssize_t tsl2x7x_luxtable_show(struct device *dev,
>  	int offset = 0;
>  
>  	while (i < (TSL2X7X_MAX_LUX_TABLE_SIZE * 3)) {
> -		offset += snprintf(buf + offset, PAGE_SIZE, "%d,%d,%d,",
> +		offset += snprintf(buf + offset, PAGE_SIZE, "%u,%u,%u,",
>  			chip->tsl2x7x_device_lux[i].ratio,
>  			chip->tsl2x7x_device_lux[i].ch0,
>  			chip->tsl2x7x_device_lux[i].ch1);
> 

