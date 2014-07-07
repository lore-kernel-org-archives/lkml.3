Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaGGKsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:48:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49171 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaGGKsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:48:05 -0400
Date: Mon, 7 Jul 2014 11:48:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: backlight: ili922x.c:  Cleaning up variable that
 is never used
Message-ID: <20140707104800.GB6407@lee--X1>
References: <1404670847-17249-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404670847-17249-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jul 2014, Rickard Strandqvist wrote:

> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/video/backlight/ili922x.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> index ea67fe1..06936c8 100644
> --- a/drivers/video/backlight/ili922x.c
> +++ b/drivers/video/backlight/ili922x.c
> @@ -251,7 +251,7 @@ static int ili922x_write(struct spi_device *spi, u8 reg, u16 value)
>  	struct spi_transfer xfer_regindex, xfer_regvalue;
>  	unsigned char tbuf[CMD_BUFSIZE];
>  	unsigned char rbuf[CMD_BUFSIZE];
> -	int ret, len = 0;
> +	int ret;
>  
>  	memset(&xfer_regindex, 0, sizeof(struct spi_transfer));
>  	memset(&xfer_regvalue, 0, sizeof(struct spi_transfer));
> @@ -273,7 +273,6 @@ static int ili922x_write(struct spi_device *spi, u8 reg, u16 value)
>  	ret = spi_sync(spi, &msg);
>  
>  	spi_message_init(&msg);
> -	len = 0;
>  	tbuf[0] = set_tx_byte(START_BYTE(ili922x_id, START_RS_REG,
>  					 START_RW_WRITE));
>  	tbuf[1] = set_tx_byte((value & 0xFF00) >> 8);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
