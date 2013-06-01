Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3FADCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 23:02:15 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:52825 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3FADCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 23:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <1370050492-6046-3-git-send-email-jwerner@chromium.org>
References: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
	<1370050492-6046-3-git-send-email-jwerner@chromium.org>
Date: Sat, 1 Jun 2013 12:01:59 +0900
Message-ID: <CADoNuNdsOCf0YKK4FksGJUfnkq_w5jxMKymZ4n67R3i4xA9Xpw@mail.gmail.com>
Subject: Re: [PATCH 2/3] usb: misc: usb3503: Remove hardcoded disabling of
 ports 2 and 3
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

Hi,

I have sent two patches for the same issue, these two are merged into
Greg's tree. Please review the patches.

[1] https://patchwork.kernel.org/patch/2599021
[2] https://patchwork.kernel.org/patch/2599031

Many thanks,
Dongjin.

On Sat, Jun 1, 2013 at 10:34 AM, Julius Werner <jwerner@chromium.org> wrote:
> The usb3503 driver currently disables port 2 and 3 without explaination.
> It doesn't make sense to do this in a mainline Linux driver that should
> support all platforms which use this chip. If specific use cases really
> require ports to be disabled, this should either be done through local
> patches or a configurable mechanism (such as a device tree property).
> Until then, let's keep all ports enabled.
>
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/misc/usb3503.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index 73aeb87..a647a2e 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -134,14 +134,6 @@ static int usb3503_switch_mode(struct usb3503 *hub, enum usb3503_mode mode)
>                         goto err_hubmode;
>                 }
>
> -               /* PDS : Port2,3 Disable For Self Powered Operation */
> -               err = usb3503_set_bits(i2c, USB3503_PDS,
> -                               (USB3503_PORT2 | USB3503_PORT3));
> -               if (err < 0) {
> -                       dev_err(&i2c->dev, "PDS failed (%d)\n", err);
> -                       goto err_hubmode;
> -               }
> -
>                 /* CFG1 : SELF_BUS_PWR -> Self-Powerd operation */
>                 err = usb3503_set_bits(i2c, USB3503_CFG1, USB3503_SELF_BUS_PWR);
>                 if (err < 0) {
> --
> 1.7.12.4
>
