Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbaHVRE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:04:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbaHVRE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:04:57 -0400
Message-ID: <53F77835.7050406@suse.com>
Date: Fri, 22 Aug 2014 13:04:53 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Kconfig: do not select SPI bus on sub-driver auto-select
References: <1408726929-3924-1-git-send-email-crope@iki.fi>
In-Reply-To: <1408726929-3924-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri Aug 22 13:02:09 2014, Antti Palosaari wrote:
> We should not select SPI bus when sub-driver auto-select is
> selected. That option is meant for auto-selecting all possible
> ancillary drivers used for selected board driver. Ancillary
> drivers should define needed dependencies itself.
>
> I2C and I2C_MUX are still selected here for a reason described on
> commit 347f7a3763601d7b466898d1f10080b7083ac4a3
>
> Reverts commit e4462ffc1602d9df21c00a0381dca9080474e27a
>
> Reported-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index f60bad4..3c89fcb 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -182,7 +182,6 @@ config MEDIA_SUBDRV_AUTOSELECT
>  	depends on HAS_IOMEM
>  	select I2C
>  	select I2C_MUX
> -	select SPI
>  	default y
>  	help
>  	  By default, a media driver auto-selects all possible ancillary

FWIW, in the patch I used locally, I also did a 'select SPI' in the 
MSI2500 driver since it wouldn't otherwise be obvious that a USB device 
depends on SPI.

-Jeff

--
Jeff Mahoney
SUSE Labs
