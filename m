Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaGBGyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:54:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65049 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaGBGyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:54:35 -0400
Date: Wed, 2 Jul 2014 07:54:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: ab8500-debugfs.c:  Cleaning up unnecessary to test,
 unsigned can't be negative.
Message-ID: <20140702065430.GB10311@lee--X1>
References: <1403991279-7109-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403991279-7109-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unsigned variable can't be negative so it is unnecessary to test it
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/mfd/ab8500-debugfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
> index d1a22aa..0793a10 100644
> --- a/drivers/mfd/ab8500-debugfs.c
> +++ b/drivers/mfd/ab8500-debugfs.c
> @@ -2504,7 +2504,7 @@ static ssize_t ab8500_gpadc_trig_timer_write(struct file *file,
>  	if (err)
>  		return err;
>  
> -	if ((user_trig_timer >= 0) && (user_trig_timer <= 255)) {
> +	if (user_trig_timer <= 255) {
>  		trig_timer = (u8) user_trig_timer;
>  	} else {
>  		dev_err(dev, "debugfs error input: "

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
