Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaCJQiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:38:18 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:57283 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaCJQiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:38:17 -0400
Date: Mon, 10 Mar 2014 16:38:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: wm5102: Mark register 0x19 readable
Message-ID: <20140310163811.GA16697@lee--X1>
References: <1394468977-23149-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394468977-23149-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown <broonie@linaro.org>
> 
> During init the core checks if the wm5102 has finished starting by reading
> register 0x19 and looking at the value. This read always fails since this
> is not a readable register, mark it as being one.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/wm5102-tables.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
> index f4668d39e542..07f024fd4ded 100644
> --- a/drivers/mfd/wm5102-tables.c
> +++ b/drivers/mfd/wm5102-tables.c
> @@ -1016,6 +1016,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_WRITE_SEQUENCER_CTRL_0:
>  	case ARIZONA_WRITE_SEQUENCER_CTRL_1:
>  	case ARIZONA_WRITE_SEQUENCER_CTRL_2:
> +	case 0x19:

Can we have a #define for these please?

>  	case ARIZONA_WRITE_SEQUENCER_PROM:
>  	case ARIZONA_TONE_GENERATOR_1:
>  	case ARIZONA_TONE_GENERATOR_2:

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
