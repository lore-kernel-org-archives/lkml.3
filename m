Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaF3RL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:11:56 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40316 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaF3RLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:11:54 -0400
Message-ID: <53B19A57.2040200@gmail.com>
Date: Mon, 30 Jun 2014 10:11:51 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 1/1] MIPS: Octeon: remove unnecessary null test before
 debugfs_remove_recursive
References: <1404026179-2910-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1404026179-2910-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2014 12:16 AM, Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required
>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

I haven't tested it, but it seems fine, so...

Acked-by: David Daney <david.daney@cavium.com>

> ---
>   arch/mips/cavium-octeon/oct_ilm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/oct_ilm.c b/arch/mips/cavium-octeon/oct_ilm.c
> index 71b213d..2d68a39 100644
> --- a/arch/mips/cavium-octeon/oct_ilm.c
> +++ b/arch/mips/cavium-octeon/oct_ilm.c
> @@ -194,8 +194,7 @@ err_irq:
>   static __exit void oct_ilm_module_exit(void)
>   {
>   	disable_timer(TIMER_NUM);
> -	if (dir)
> -		debugfs_remove_recursive(dir);
> +	debugfs_remove_recursive(dir);
>   	free_irq(OCTEON_IRQ_TIMER0 + TIMER_NUM, 0);
>   }
>
>

