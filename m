Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaI2HeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 03:34:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:35291 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaI2HeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 03:34:20 -0400
Date: Mon, 29 Sep 2014 09:34:25 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Pramod Gurav <pramod.gurav@smartplayin.com>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: atmel-mci: fix mismatched section on
 atmci_cleanup_slot
Message-ID: <20140929073425.GD1868@ldesroches-Latitude-E6320>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Pramod Gurav <pramod.gurav@smartplayin.com>,
	linux-kernel@vger.kernel.org, Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
References: <1411467606-13041-1-git-send-email-pramod.gurav@smartplayin.com>
 <1411467606-13041-2-git-send-email-pramod.gurav@smartplayin.com>
 <201409262134.58457.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201409262134.58457.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 09:34:58PM +0200, Arnd Bergmann wrote:
> As of 528bc7808f4e ("mmc: atmel-mci: Release mmc resources on failure in probe"),
> the atmci_probe() function calls atmci_cleanup_slot in the failure path.
> 
> This causes a new warning whenever the driver is built:
> 
> WARNING: drivers/mmc/host/built-in.o(.init.text+0xa04): Section mismatch in reference from the function atmci_probe() to the function .exit.text:atmci_cleanup_slot()
> The function __init atmci_probe() references
> a function __exit atmci_cleanup_slot().
> 
> Gcc correctly warns about this function getting dropped in the link stage
> for the built-in case, which would cause undefined behavior when this error
> path is hit. The solution is to simply drop the __exit annotation.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Thanks, I also missed this warning when compiling.

> Fixes: 528bc7808f4e ("mmc: atmel-mci: Release mmc resources on failure in probe")
> 
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 772ef5b0e4d5..974626087732 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -2244,7 +2244,7 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>  	return 0;
>  }
>  
> -static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot,
> +static void atmci_cleanup_slot(struct atmel_mci_slot *slot,
>  		unsigned int id)
>  {
>  	/* Debugfs stuff is cleaned up by mmc core */
