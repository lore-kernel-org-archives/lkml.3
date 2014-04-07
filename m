Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaDGNOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:14:08 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60892 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaDGNOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:14:07 -0400
MIME-Version: 1.0
In-Reply-To: <1396339273-15904-1-git-send-email-tlinder@codeaurora.org>
References: <1396339273-15904-1-git-send-email-tlinder@codeaurora.org>
Date: Mon, 7 Apr 2014 15:14:05 +0200
Message-ID: <CAFLxGvwXXx2q=yRW6agt5pjJkfnYB40j_u7udLP7yOSHP8eLmw@mail.gmail.com>
Subject: Re: [RFC/PATCH] mtd: ubi: Test return value of __wl_get_peb
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 10:01 AM, Tanya Brokhman <tlinder@codeaurora.org> wrote:
> In case of an error (if there are not free PEB's for example),
> __wl_get_peb will return a negative value. In order to prevent access
> violation we need to test the returned value prior to using it later on.
>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 02317c1..457ead3 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -684,6 +684,9 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
>         peb = __wl_get_peb(ubi);
>         spin_unlock(&ubi->wl_lock);
>
> +       if (peb < 0)
> +               return peb;
> +
>         err = ubi_self_check_all_ff(ubi, peb, ubi->vid_hdr_aloffset,
>                                     ubi->peb_size - ubi->vid_hdr_aloffset);
>         if (err) {

Acked-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
