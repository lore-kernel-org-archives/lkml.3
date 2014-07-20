Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaGTJu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 05:50:58 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:55754 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaGTJu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 05:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140719234843.GA28580@core.coreip.homeip.net>
References: <20140719234843.GA28580@core.coreip.homeip.net>
Date: Sun, 20 Jul 2014 11:50:55 +0200
Message-ID: <CANq1E4QWcngK8VeEcKzx-5XqUan3kBRKjk7HXjE_SRV+9Umb5g@mail.gmail.com>
Subject: Re: [PATCH] Input: fix defuzzing logic
From: David Herrmann <dh.herrmann@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Andrew de los Reyes <adlr@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Jul 20, 2014 at 1:49 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> We attempt to remove noise from coordinates reported by devices in
> input_handle_abs_event(), unfortunately, unless we were dropping the
> event altogether, we were ignoring the adjusted value and were passing
> on the original value instead.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Reviewed-by: Andrew de los Reyes <adlr@chromium.org>
> Reviewed-by: Benson Leung <bleung@chromium.org>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/input.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 1c4c0db..29ca0bb 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -257,9 +257,10 @@ static int input_handle_abs_event(struct input_dev *dev,
>  }
>
>  static int input_get_disposition(struct input_dev *dev,
> -                         unsigned int type, unsigned int code, int value)
> +                         unsigned int type, unsigned int code, int *pval)
>  {
>         int disposition = INPUT_IGNORE_EVENT;
> +       int value = *pval;
>
>         switch (type) {
>
> @@ -357,6 +358,7 @@ static int input_get_disposition(struct input_dev *dev,
>                 break;
>         }
>
> +       *pval = value;
>         return disposition;
>  }
>
> @@ -365,7 +367,7 @@ static void input_handle_event(struct input_dev *dev,
>  {
>         int disposition;
>
> -       disposition = input_get_disposition(dev, type, code, value);
> +       disposition = input_get_disposition(dev, type, code, &value);
>
>         if ((disposition & INPUT_PASS_TO_DEVICE) && dev->event)
>                 dev->event(dev, type, code, value);
>
> --
> Dmitry
