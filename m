Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3L2V6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:58:06 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62801 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3L2V6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:58:03 -0500
MIME-Version: 1.0
In-Reply-To: <1388357260-4843-20-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
	<1388357260-4843-20-git-send-email-Julia.Lawall@lip6.fr>
Date: Sun, 29 Dec 2013 22:58:02 +0100
X-Google-Sender-Auth: qB4KTGOkrEDrRhNiVA7fOg2Pn7o
Message-ID: <CAMuHMdWQ5oiXsL7j3T0yuDhFe6uumwcv0S1Ym-L+uTwqqAvCcA@mail.gmail.com>
Subject: Re: [PATCH 19/25] fix error return code
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Geoff Levand <geoff@infradead.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "cbe-oss-dev@lists.ozlabs.org" <cbe-oss-dev@lists.ozlabs.org>,
        scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 11:47 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Set the return variable to an error code as done elsewhere in the function.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
>
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
> Not tested.
>
>  drivers/scsi/ps3rom.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index e6e2a30..04d77ce 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -387,6 +387,7 @@ static int ps3rom_probe(struct ps3_system_bus_device *_dev)
>         if (!host) {
>                 dev_err(&dev->sbd.core, "%s:%u: scsi_host_alloc failed\n",
>                         __func__, __LINE__);
> +               error = -ENOMEM;
>                 goto fail_teardown;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
