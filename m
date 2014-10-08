Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaJHRJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:09:30 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:53518 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbaJHRJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <20141008165425.GA23281@dtor-ws>
References: <20141008165425.GA23281@dtor-ws>
Date: Wed, 8 Oct 2014 19:09:28 +0200
Message-ID: <CANq1E4QDfrAJfosA8cDxO4wxJSbMbpfZpms44s6g_h9F2RANdw@mail.gmail.com>
Subject: Re: [PATCH] Input: automatically set EV_ABS bit in input_set_abs_params
From: David Herrmann <dh.herrmann@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>, jikos@jikos.cz,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Oct 8, 2014 at 6:54 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Let's automatically set EV_ABS bit in device's event type list when calling
> input_set_abs_params() so that drivers do not have to do it explicitly.
>
> These calls are never in a hot paths so we won't lose much time by setting
> the same bit several times.

Looks good to me. I mean we already do the absbit-allocation here, so
this looks sane to do.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 29ca0bb..d2e06cc 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -498,7 +498,8 @@ void input_set_abs_params(struct input_dev *dev, unsigned int axis,
>         absinfo->fuzz = fuzz;
>         absinfo->flat = flat;
>
> -       dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
> +       __set_bit(EV_ABS, dev->evbit);
> +       __set_bit(axis, dev->absbit);
>  }
>  EXPORT_SYMBOL(input_set_abs_params);
>
>
> --
> Dmitry
