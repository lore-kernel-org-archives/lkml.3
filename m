Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaADFNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 00:13:13 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45066 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaADFNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 00:13:11 -0500
MIME-Version: 1.0
In-Reply-To: <20140104050058.GA20652@core.coreip.homeip.net>
References: <20140104050058.GA20652@core.coreip.homeip.net>
Date: Fri, 3 Jan 2014 21:13:10 -0800
Message-ID: <CAHQ1cqGZT7TOCX+5yPhWt1MpsSbAfbr07SProgSxrn7RO=7aig@mail.gmail.com>
Subject: Re: [PATCH] Input: ims-pcu - fix error unwinding path in application mode
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Chris Healy <chealy@imsco-us.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Do you want this patch to go separatly or do you want me to bundle it
with my other changes(probably the first one)?
Also, offtopic, do you want me to backport this changes to 2.6 kernel
that IMS uses or would you do it?

Thanks,

On Fri, Jan 3, 2014 at 9:00 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> We first create backlight and then input devices so we shoudl destroy them
> in opposite order when handling errors.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>
> Andrey, this fixup was split off from the patch I sent earlier today.
>
>  drivers/input/misc/ims-pcu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
> index 4244f47..513ecdf 100644
> --- a/drivers/input/misc/ims-pcu.c
> +++ b/drivers/input/misc/ims-pcu.c
> @@ -1929,10 +1929,10 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
>
>         return 0;
>
> -err_destroy_backlight:
> -       ims_pcu_destroy_backlight(pcu);
>  err_destroy_buttons:
>         ims_pcu_destroy_buttons(pcu);
> +err_destroy_backlight:
> +       ims_pcu_destroy_backlight(pcu);
>         return error;
>  }
>
> --
> 1.8.4.2
>
>
> --
> Dmitry
