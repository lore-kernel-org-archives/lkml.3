Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbbATUnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:43:35 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36965 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbATUnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:43:33 -0500
Message-ID: <54BEBDF1.8090909@kernel.org>
Date: Tue, 20 Jan 2015 20:43:29 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Asaf Vertz <asaf.vertz@tandemg.com>, gregkh@linuxfoundation.org
CC: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, mwelling@ieee.org,
        daniel.baluta@intel.com, aybuke.147@gmail.com,
        monamagarwal123@gmail.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: tsl2583: fix format string warnings
References: <20150120104338.GA17675@ubuntu>
In-Reply-To: <20150120104338.GA17675@ubuntu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 10:43, Asaf Vertz wrote:
> Fixed the following warnings (reported by cppcheck):
> [drivers/staging/iio/light/tsl2583.c:695]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/staging/iio/light/tsl2583.c:695]: (warning) %d in format string (no. 2)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/staging/iio/light/tsl2583.c:695]: (warning) %d in format string (no. 3)
> requires 'int' but the argument type is 'unsigned int'.
> 
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
Applied to the togreg branch of iio.git - initially pushed out
as testing.  Note this branch will almost certainly get rebased
before going upstream.

Jonathan
> ---
>  drivers/staging/iio/light/tsl2583.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
> index cc4ddcc..8afae8e 100644
> --- a/drivers/staging/iio/light/tsl2583.c
> +++ b/drivers/staging/iio/light/tsl2583.c
> @@ -692,7 +692,7 @@ static ssize_t taos_luxtable_show(struct device *dev,
>  	int offset = 0;
>  
>  	for (i = 0; i < ARRAY_SIZE(taos_device_lux); i++) {
> -		offset += sprintf(buf + offset, "%d,%d,%d,",
> +		offset += sprintf(buf + offset, "%u,%u,%u,",
>  				  taos_device_lux[i].ratio,
>  				  taos_device_lux[i].ch0,
>  				  taos_device_lux[i].ch1);
> 

