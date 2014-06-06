Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaFFGx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:53:58 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63321 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaFFGx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:53:57 -0400
Date: Fri, 6 Jun 2014 07:53:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] mfd: UCB1x00: enable modular build
Message-ID: <20140606065351.GL24240@lee--X1>
References: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
 <1402003454-1989084-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402003454-1989084-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The UCB1200 / UCB1300 driver uses the MCP_SA11X0 driver, which
> can be a loadable module, but this results in a link error
> when UCB1200 itself is built-in:
> 
> drivers/built-in.o: In function `ucb1x00_io_set_dir':
> :(.text+0x4a364): undefined reference to `mcp_reg_write'
> drivers/built-in.o: In function `ucb1x00_io_write':
> :(.text+0x4a3dc): undefined reference to `mcp_reg_write'
> drivers/built-in.o: In function `ucb1x00_io_read':
> :(.text+0x4a400): undefined reference to `mcp_reg_read'
> drivers/built-in.o: In function `ucb1x00_adc_enable':
> :(.text+0x4a460): undefined reference to `mcp_enable'
> ...
> 
> This can easily be resolved by making CONFIG_MCP_UCB1200 itself
> a tristate option, since that causes Kconfig to track the
> dependency correctly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/mfd/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index ee8204c..4370692 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1248,7 +1248,7 @@ config MCP_SA11X0
>  
>  # Chip drivers
>  config MCP_UCB1200
> -	bool "Support for UCB1200 / UCB1300"
> +	tristate "Support for UCB1200 / UCB1300"
>  	depends on MCP_SA11X0
>  	select MCP
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
