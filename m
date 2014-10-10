Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaJJLae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:30:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaJJLaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:30:30 -0400
Date: Fri, 10 Oct 2014 13:30:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Hans de Goede <hdegoede@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: automatically set EV_ABS bit in
 input_set_abs_params
In-Reply-To: <20141008165425.GA23281@dtor-ws>
Message-ID: <alpine.LNX.2.00.1410101330030.31343@pobox.suse.cz>
References: <20141008165425.GA23281@dtor-ws>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014, Dmitry Torokhov wrote:

> Let's automatically set EV_ABS bit in device's event type list when calling
> input_set_abs_params() so that drivers do not have to do it explicitly.
> 
> These calls are never in a hot paths so we won't lose much time by setting
> the same bit several times.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Makes sense.

	Acked-by: Jiri Kosina <jkosina@suse.cz>

Thanks.

> ---
>  drivers/input/input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 29ca0bb..d2e06cc 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -498,7 +498,8 @@ void input_set_abs_params(struct input_dev *dev, unsigned int axis,
>  	absinfo->fuzz = fuzz;
>  	absinfo->flat = flat;
>  
> -	dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
> +	__set_bit(EV_ABS, dev->evbit);
> +	__set_bit(axis, dev->absbit);
>  }
>  EXPORT_SYMBOL(input_set_abs_params);

-- 
Jiri Kosina
SUSE Labs
