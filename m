Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbaKSADN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:03:13 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:18944 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaKSADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:03:11 -0500
Date: Wed, 19 Nov 2014 00:03:08 +0000
From: James Hogan <james.hogan@imgtec.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        James Hartley <james.hartley@imgtec.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: img-scb: Allow building for MIPS
Message-ID: <20141119000308.GL1739@jhogan-linux.le.imgtec.org>
References: <1416355113-8942-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1416355113-8942-1-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:58:33PM -0800, Andrew Bresticker wrote:
> The SCB is present on IMG SoCs other than the META-based TZ1090,
> such as the MIPS-based Pistachio SoC.  Relax the Kconfig dependency
> so that it can be built on any MIPS or META machine.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>

Looks good to me.

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
> Based on i2c/for-next
> ---
>  drivers/i2c/busses/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 03c6119..16c649a 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -526,10 +526,10 @@ config I2C_IBM_IIC
>  
>  config I2C_IMG
>  	tristate "Imagination Technologies I2C SCB Controller"
> -	depends on SOC_TZ1090 || COMPILE_TEST
> +	depends on MIPS || METAG || COMPILE_TEST
>  	help
>  	  Say Y here if you want to use the IMG I2C SCB controller,
> -	  available on the TZ1090 SoC.
> +	  available on the TZ1090 and other IMG SoCs.
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-img-scb.
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
