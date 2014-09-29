Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaI2Jna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:43:30 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:57713 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaI2Jn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <201409262134.58457.arnd@arndb.de>
References: <1411467606-13041-1-git-send-email-pramod.gurav@smartplayin.com>
	<1411467606-13041-2-git-send-email-pramod.gurav@smartplayin.com>
	<201409262134.58457.arnd@arndb.de>
Date: Mon, 29 Sep 2014 11:43:28 +0200
Message-ID: <CAPDyKFoj6jKOF6e5fN3Yt3VpiHQ4Da8sJHc6tK3K17MO0V-PEQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: atmel-mci: fix mismatched section on atmci_cleanup_slot
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2014 21:34, Arnd Bergmann <arnd@arndb.de> wrote:
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
> Fixes: 528bc7808f4e ("mmc: atmel-mci: Release mmc resources on failure in probe")

Thanks! Applied for next!

Kind regards
Uffe

>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 772ef5b0e4d5..974626087732 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -2244,7 +2244,7 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>         return 0;
>  }
>
> -static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot,
> +static void atmci_cleanup_slot(struct atmel_mci_slot *slot,
>                 unsigned int id)
>  {
>         /* Debugfs stuff is cleaned up by mmc core */
