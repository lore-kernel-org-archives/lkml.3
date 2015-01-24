Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbbAXGVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 01:21:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54180 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbbAXGVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 01:21:21 -0500
Date: Fri, 23 Jan 2015 22:21:20 -0800 (PST)
Message-Id: <20150123.222120.467596005244092508.davem@davemloft.net>
To: m-karicheri2@ti.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next] net: netcp: remove unused kconfig option and code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421781756-11151-1-git-send-email-m-karicheri2@ti.com>
References: <1421781756-11151-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Jan 2015 22:21:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Tue, 20 Jan 2015 14:22:36 -0500

> Currently CPTS is built into the netcp driver even though there is no
> call out to the CPTS driver. This patch removes the dependency in Kconfig
> and remove cpts.o from the Makefile for NetCP.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/net/ethernet/ti/Kconfig  |    2 +-
>  drivers/net/ethernet/ti/Makefile |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index e11bcfa..824e376 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -73,7 +73,7 @@ config TI_CPSW
>  config TI_CPTS
>  	boolean "TI Common Platform Time Sync (CPTS) Support"
>  	depends on TI_CPSW
> -	depends on TI_CPSW || TI_KEYSTONE_NET
> +	depends on TI_CPSW

Just remove the second dependency line, it's redundant because you've
made it identical to the line before it.
