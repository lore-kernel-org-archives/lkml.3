Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbbAULgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:36:18 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61058 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAULgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:36:07 -0500
MIME-Version: 1.0
In-Reply-To: <1421545862-24102-1-git-send-email-der.herr@hofr.at>
References: <1421545862-24102-1-git-send-email-der.herr@hofr.at>
Date: Wed, 21 Jan 2015 12:36:05 +0100
Message-ID: <CAPDyKFq9PisvGUgvJJF+X4AeBaSL5wgF371OOHGR8s=SRXuYEg@mail.gmail.com>
Subject: Re: [PATCH] mmc: vub300: remove unreachable return value handling
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Tony Olech <tony.olech@elandigitalsystems.com>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 January 2015 at 02:51, Nicholas Mc Guire <der.herr@hofr.at> wrote:
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>
> The return value of wait_for_completion_timeout is unsigned long,
> as it is used here for wait_for_completion_timeout only the type
> of commretval was changed to unsigned long.
>
> As wait_for_completion_timeout does not return negative values
> the commretval < 0 case is not reachable and can be removed.
>
> This was only compile-tested for x86_64_defconfig + CONFIG_MMC=m,
> CONFIG_MMC_VUB300=m
>
> Patch is against 3.19.0-rc4 -next-20150116
>
>  drivers/mmc/host/vub300.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
> index 4262296..fbabbb8 100644
> --- a/drivers/mmc/host/vub300.c
> +++ b/drivers/mmc/host/vub300.c
> @@ -659,7 +659,7 @@ static void __vub300_irqpoll_response(struct vub300_mmc_host *vub300)
>  static void __do_poll(struct vub300_mmc_host *vub300)
>  {
>         /* cmd_mutex is held by vub300_pollwork_thread */
> -       long commretval;
> +       unsigned long commretval;
>         mod_timer(&vub300->inactivity_timer, jiffies + HZ);
>         init_completion(&vub300->irqpoll_complete);
>         send_irqpoll(vub300);
> @@ -671,8 +671,6 @@ static void __do_poll(struct vub300_mmc_host *vub300)
>                 vub300->usb_timed_out = 1;
>                 usb_kill_urb(vub300->command_out_urb);
>                 usb_kill_urb(vub300->command_res_urb);
> -       } else if (commretval < 0) {
> -               vub300_queue_poll_work(vub300, 1);
>         } else { /* commretval > 0 */
>                 __vub300_irqpoll_response(vub300);
>         }
> --
> 1.7.10.4
>
