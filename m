Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaI0DPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 23:15:36 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:36713 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaI0DPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 23:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <201409262134.58457.arnd@arndb.de>
References: <1411467606-13041-1-git-send-email-pramod.gurav@smartplayin.com>
	<1411467606-13041-2-git-send-email-pramod.gurav@smartplayin.com>
	<201409262134.58457.arnd@arndb.de>
Date: Sat, 27 Sep 2014 08:45:33 +0530
Message-ID: <CAMf-jSkc7pCeqd6MfZJXKGWB6M=qA+c+yUCPaQ=UQ7r9E7R_xw@mail.gmail.com>
Subject: Re: [PATCH] mmc: atmel-mci: fix mismatched section on atmci_cleanup_slot
From: Pramod Gurav <pramod.gurav.etc@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sat, Sep 27, 2014 at 1:04 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> As of 528bc7808f4e ("mmc: atmel-mci: Release mmc resources on failure in probe"),
> the atmci_probe() function calls atmci_cleanup_slot in the failure path.
>
> This causes a new warning whenever the driver is built:
>
> WARNING: drivers/mmc/host/built-in.o(.init.text+0xa04): Section mismatch in reference from the function atmci_probe() to the function .exit.text:atmci_cleanup_slot()
> The function __init atmci_probe() references
> a function __exit atmci_cleanup_slot().
Thanks for this though I am not owner of the driver but the last
commit was mine.
but how come I did not see this warning? Any flag with compiler that
warned about this?
>
> Gcc correctly warns about this function getting dropped in the link stage
> for the built-in case, which would cause undefined behavior when this error
> path is hit. The solution is to simply drop the __exit annotation.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 528bc7808f4e ("mmc: atmel-mci: Release mmc resources on failure in probe")
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
