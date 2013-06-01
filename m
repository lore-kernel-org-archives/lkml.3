Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3FADML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 23:12:11 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:41403 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab3FADIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 23:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <1370050492-6046-4-git-send-email-jwerner@chromium.org>
References: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
	<1370050492-6046-4-git-send-email-jwerner@chromium.org>
Date: Sat, 1 Jun 2013 12:08:48 +0900
Message-ID: <CADoNuNfuQQneRLi7mX0pjZU+eSuBdJ4M9sude=f1Y1dPTkwAPA@mail.gmail.com>
Subject: Re: [PATCH 3/3] usb: misc: usb3503: Remove 100ms sleep on reset,
 conform to data sheet
From: Dongjin Kim <tobetter@gmail.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongjin Kim <tobetter@gmail.com>

On Sat, Jun 1, 2013 at 10:34 AM, Julius Werner <jwerner@chromium.org> wrote:
> The usb3503 driver sleeps a flat 100ms when resetting the chip, with a
> comment about waiting for the reference clock. This seems to be a
> board-specific detail that should not hold up boot across all platforms.
> This patch reduces the sleep to the 4ms initialization delay that the
> chip itself actually requires (as per its data sheet). If certain boards
> require more time to set up the reference clock, they should change this
> through local patches or add a proper, configurable synchronization
> mechanism.
>
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/misc/usb3503.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index a647a2e..a1d509f 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -107,11 +107,9 @@ static int usb3503_reset(int gpio_reset, int state)
>         if (gpio_is_valid(gpio_reset))
>                 gpio_set_value(gpio_reset, state);
>
> -       /* Wait RefClk when RESET_N is released, otherwise Hub will
> -        * not transition to Hub Communication Stage.
> -        */
> +       /* Wait T_HUBINIT == 4ms for hub logic to stabilize */
>         if (state)
> -               msleep(100);
> +               usleep_range(4000, 10000);
>
>         return 0;
>  }
> --
> 1.7.12.4
>
