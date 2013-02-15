Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3BOTye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:54:34 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:39489 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3BOTyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:54:32 -0500
MIME-Version: 1.0
In-Reply-To: <1360956981-1112-2-git-send-email-rydberg@euromail.se>
References: <1360956981-1112-1-git-send-email-rydberg@euromail.se> <1360956981-1112-2-git-send-email-rydberg@euromail.se>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 15 Feb 2013 11:54:11 -0800
X-Google-Sender-Auth: mfLmZcdmLj8VoX9aOE0AmMvWOKw
Message-ID: <CAGS+omC2Yemvo-kE9tYOmE4rou4fi2iNOXw3v3c+A91_kiUzfQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: synaptics - initialize pointer emulation usage
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:36 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> To properly setup event parameters for emulated events, pass
> the appropriate flag to the slot initialization function. Also,
> all MT-related events should be setup before initialization.
>
> Incidentally, this solves the issue of doubly filtered pointer
> events.
>
> Reported-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Daniel,
>
> This patch has only been compile tested, but chances are that it will
> work for you, together with the previous patch.
>
> Cheers,
> Henrik
>
>  drivers/input/mouse/synaptics.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 12d12ca..a8590ad 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -1247,11 +1247,11 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>         input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
>
>         if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
> -               input_mt_init_slots(dev, 2, 0);
>                 set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
>                                         ABS_MT_POSITION_Y);
>                 /* Image sensors can report per-contact pressure */
>                 input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
> +               input_mt_init_slots(dev, 2, INPUT_MT_POINTER);

ABS_X/Y/PRESSURE are already init'ed in the common code a few lines
above the if ().
Perhaps you could refactor things a bit to only define them once?

Thanks,
-Dan

>
>                 /* Image sensors can signal 4 and 5 finger clicks */
>                 __set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> --
> 1.8.1.2
>
