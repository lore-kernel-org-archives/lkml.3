Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLXCOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 21:14:34 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52536 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaLXCOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 21:14:33 -0500
MIME-Version: 1.0
In-Reply-To: <49ea5f8dc52545d4a5df6b1ad8302410@HT17-E6.exg6.exghost.com>
References: <49ea5f8dc52545d4a5df6b1ad8302410@HT17-E6.exg6.exghost.com>
Date: Tue, 23 Dec 2014 21:14:31 -0500
X-Google-Sender-Auth: TXmSELNgu7cNsNPcCoP5q9GDhKI
Message-ID: <CADvA-dk0hAScoj=_rxrO6hJAP0BgSRF81t1w=xWiwYbg+s9TMw@mail.gmail.com>
Subject: Re: [PATCH] incorrect use of init_completion fixup
From: Ed Cashin <ecashin@noserose.net>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 12:44 PM, Nicholas Mc Guire <der.herr@hofr.at> wrote:
>
> The second init_completion call should be a reinit_completion here.
>
> patch is against 3.18.0 linux-next
>
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/block/aoe/aoecmd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index 422b7d8..2239513 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -1331,7 +1331,7 @@ aoe_ktstart(struct ktstate *k)
>                 return -ENOMEM;
>         k->task = task;
>         wait_for_completion(&k->rendez); /* allow kthread to start */
> -       init_completion(&k->rendez);    /* for waiting for exit later */
> +       reinit_completion(&k->rendez);  /* for waiting for exit later */
>         return 0;
>  }

That looks good to me, thanks.

-- 
  Ed Cashin <ecashin@noserose.net>
