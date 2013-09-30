Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3I3IRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:17:20 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50742 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3I3IRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <1380376516-30144-8-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at> <1380376516-30144-8-git-send-email-richard@nod.at>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 30 Sep 2013 10:16:57 +0200
Message-ID: <CACQ1gAiaSeF0EP9KubJ7SRrLFc=gKq+wEHenFFw-BxJoCx203Q@mail.gmail.com>
Subject: Re: [PATCH 7/7] UBI: Add some asserts to ubi_attach_fastmap()
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/28 Richard Weinberger <richard@nod.at>:
> Add more paranioa asserts to make it easier to detect
> implementation errors.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/fastmap.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index 4cfc8da..ead8613 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -826,6 +826,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
>         list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list)
>                 list_move_tail(&tmp_aeb->u.list, &ai->free);
>
> +       ubi_assert(list_empty(&used));
> +       ubi_assert(list_empty(&eba_orphans));
> +       ubi_assert(list_empty(&free));
> +
>         /*
>          * If fastmap is leaking PEBs (must not happen), raise a
>          * fat warning and fall back to scanning mode.
> --
> 1.8.3.1
>

Tested-by: Richard Genoud <richard.genoud@gmail.com>
