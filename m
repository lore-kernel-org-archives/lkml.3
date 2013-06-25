Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3FYHcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:32:47 -0400
Received: from csmtp3.one.com ([91.198.169.23]:34499 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3FYHcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:32:46 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 03:32:46 EDT
Date: Tue, 25 Jun 2013 09:27:28 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc/bmp085: Enable building as a module
Message-ID: <20130625072728.GB24258@scully.xfiles.lan>
References: <1372083021.21189.19.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372083021.21189.19.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:10 Mon 24 Jun     , Ben Hutchings wrote:
> Commit 985087dbcb02 'misc: add support for bmp18x chips to the bmp085
> driver' changed the BMP085 config symbol to a boolean.  I see no
> reason why the shared code cannot be built as a module, so change it
> back to tristate.
> 
> Cc: Eric Andersson <eric.andersson@unixphere.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/misc/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index c002d86..7a68184 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -451,7 +451,7 @@ config ARM_CHARLCD
>  	  still useful.
>  
>  config BMP085
> -	bool
> +	tristate
>  	depends on SYSFS
>  
>  config BMP085_I2C
> 

There is no reason for building the common code stand-alone. The BMP085
config option is only selectable via the BMP085_I2C/_SPI options.
See the select-statement for those options:

 config BMP085_I2C
	tristate "BMP085 digital pressure sensor on I2C"
	select BMP085
 ...

-- 
Best regards,
 Eric

 http://www.unixphere.com
