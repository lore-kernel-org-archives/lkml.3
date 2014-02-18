Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaBRKkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:40:16 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38522 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaBRKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:40:14 -0500
Message-ID: <530338B2.603@kernel.org>
Date: Tue, 18 Feb 2014 10:40:50 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net
CC: pmeerw@pmeerw.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, hns@goldelico.com
Subject: Re: [PATCH 1/2] staging: iio: hmc5843: Add all available models to
 device tree id table.
References: <1392387929-31491-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1392387929-31491-1-git-send-email-marek@goldelico.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/14 14:25, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
I wonder how this got missed.  However, for those data elements to be useful, you will
need to read them somewhere in the driver I think.... (if there is any magic
that puts this in the relevant i2c locations then point it out to me!)
> ---
>   drivers/staging/iio/magnetometer/hmc5843.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
> index d4f4dd9..f595fdc 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843.c
> @@ -630,7 +630,9 @@ static const struct i2c_device_id hmc5843_id[] = {
>   MODULE_DEVICE_TABLE(i2c, hmc5843_id);
>
>   static const struct of_device_id hmc5843_of_match[] = {
> -	{ .compatible = "honeywell,hmc5843" },
> +	{ .compatible = "honeywell,hmc5843", .data = (void *)HMC5843_ID },
> +	{ .compatible = "honeywell,hmc5883", .data = (void *)HMC5883_ID },
> +	{ .compatible = "honeywell,hmc5883l", .data = (void *)HMC5883L_ID },
>   	{}
>   };
>   MODULE_DEVICE_TABLE(of, hmc5843_of_match);
>

