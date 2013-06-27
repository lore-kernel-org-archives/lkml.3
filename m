Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3F0P2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:28:37 -0400
Received: from void.printf.net ([89.145.121.20]:54500 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab3F0P2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:28:35 -0400
From: Chris Ball <cjb@laptop.org>
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v1] mmc: card: fixing an false identification of SANITIZE command
References: <1370430804-5663-1-git-send-email-ygardi@codeaurora.org>
Date: Thu, 27 Jun 2013 11:28:32 -0400
In-Reply-To: <1370430804-5663-1-git-send-email-ygardi@codeaurora.org> (Yaniv
	Gardi's message of "Wed, 5 Jun 2013 14:13:08 +0300")
Message-ID: <874ncjpo7z.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yaniv,

On Wed, Jun 05 2013, Yaniv Gardi wrote:
> Inside the routine mmc_blk_ioctl_cmd() the sanitize command is
> identified according to the value of bits 16-23 of the argument.
>
> but what happens if a different command is sent, and only by chance,
> bits 16-23 contain the value of SANITIZE command ?
> In that case a SANITIZE command will be falsely identified.
> In order to prevent such a case, the condition is expanded and
> now it also checks the opcode itself, and verifies that it is an
> MMC_SWITCH opcode.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> ---
>  drivers/mmc/card/block.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index c900d28..9775ae7 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -542,7 +542,9 @@ static int mmc_blk_ioctl_cmd(struct block_device *bdev,
>  			goto cmd_rel_host;
>  	}
>  
> -	if (MMC_EXTRACT_INDEX_FROM_ARG(cmd.arg) == EXT_CSD_SANITIZE_START) {
> +	if ((MMC_EXTRACT_INDEX_FROM_ARG(cmd.arg) == EXT_CSD_SANITIZE_START) &&
> +	     (cmd.opcode == MMC_SWITCH)) {
> +
>  		err = ioctl_do_sanitize(card);
>  
>  		if (err)

Thanks, pushed to mmc-next for 3.11.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
