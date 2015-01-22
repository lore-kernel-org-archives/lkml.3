Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbbAVHpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:45:08 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38164 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbAVHpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:45:03 -0500
Date: Thu, 22 Jan 2015 07:44:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: ux500: Move struct
Message-ID: <20150122074458.GL22024@x1>
References: <1421881782-23716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421881782-23716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line is not a good one.  Please elaborate.

> Move struct ab8500_ext_regulator_cfg to  the only file that is now used in.

                   Attention to detail --^

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/regulator/ab8500-ext.c   |    6 ++++++
>  include/linux/regulator/ab8500.h |    5 -----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index 84c1ee3..a40c701 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -25,6 +25,12 @@
>  #include <linux/mfd/abx500/ab8500.h>
>  #include <linux/regulator/ab8500.h>
>  
> +

Superfluous '\n'.

> +/* AB8500 external regulators */

No need for this commit now.

> +struct ab8500_ext_regulator_cfg {
> +	bool hwreq; /* requires hw mode or high power mode */
> +};
> +

Are you sure a struct is required at all now?  It only contains a
single bool after all.

>  /**
>   * struct ab8500_ext_regulator_info - ab8500 regulator information
>   * @dev: device pointer
> diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
> index d8ecefa..802529b 100644
> --- a/include/linux/regulator/ab8500.h
> +++ b/include/linux/regulator/ab8500.h
> @@ -300,11 +300,6 @@ enum ab8540_regulator_reg {
>  	AB8540_NUM_REGULATOR_REGISTERS,
>  };
>  
> -/* AB8500 external regulators */
> -struct ab8500_ext_regulator_cfg {
> -	bool hwreq; /* requires hw mode or high power mode */
> -};
> -
>  enum ab8500_ext_regulator_id {
>  	AB8500_EXT_SUPPLY1,
>  	AB8500_EXT_SUPPLY2,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
