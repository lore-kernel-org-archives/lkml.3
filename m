Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3FGScQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:32:16 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62376 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab3FGScP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <1370551945-8444-9-git-send-email-keescook@chromium.org>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
	<1370551945-8444-9-git-send-email-keescook@chromium.org>
Date: Fri, 7 Jun 2013 11:32:14 -0700
X-Google-Sender-Auth: XGMXdL4Zp5RrvcnjnDlZnFZMHzI
Message-ID: <CAGXu5j+KfgZkhZNzxfCrY3sZS_oRTMwz1vKmd5QvP5rCw7EpfQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] isdn: clean up debug format string usage
From: Kees Cook <keescook@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 1:52 PM, Kees Cook <keescook@chromium.org> wrote:
> Avoid unneeded local string buffers for constructing debug output. Also
> cleans up debug calls that contain a single parameter so that they cannot
> be accidentally parsed as format strings.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Karsten Keil <isdn@linux-pingi.de>
> [...]
> diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
> index 8b1a66c..88305c9 100644
> --- a/drivers/isdn/mISDN/dsp_pipeline.c
> +++ b/drivers/isdn/mISDN/dsp_pipeline.c
> @@ -102,7 +102,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
>         entry->dev.class = elements_class;
>         entry->dev.release = mISDN_dsp_dev_release;
>         dev_set_drvdata(&entry->dev, elem);
> -       dev_set_name(&entry->dev, "%s", elem->name);
> +       dev_set_name(&entry->dev, elem->name);
>         ret = device_register(&entry->dev);
>         if (ret) {
>                 printk(KERN_ERR "%s: failed to register %s\n",

This hunk should be dropped -- it got mixed up when splitting the
dev_set_name() patch out.

-Kees

--
Kees Cook
Chrome OS Security
