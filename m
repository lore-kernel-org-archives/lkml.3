Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaDGNSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:18:41 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:38803 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaDGNSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <1396339327-16090-1-git-send-email-tlinder@codeaurora.org>
References: <1396339327-16090-1-git-send-email-tlinder@codeaurora.org>
Date: Mon, 7 Apr 2014 15:18:37 +0200
Message-ID: <CAFLxGvyHL2Fjk3Zvqr5Y89R7vC8wjWwUi98UESdX-Ue9h6y3pA@mail.gmail.com>
Subject: Re: [RFC/PATCH] mtd: ubi: Fix ubi free PEBs count calculation
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 10:02 AM, Tanya Brokhman <tlinder@codeaurora.org> wrote:
> The ubi->free_count should be updated with every insert/remove to/from
> the ubi->free list.
>
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
>
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 9a36f78..ca74d19 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -690,6 +690,8 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
>
>         e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
>         self_check_in_wl_tree(ubi, e, &ubi->free);
> +       ubi->free_count--;
> +       ubi_assert(ubi->free_count >= 0);
>         rb_erase(&e->u.rb, &ubi->free);
>
>         return e;
> @@ -1090,6 +1092,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
>
>                         /* Give the unused PEB back */
>                         wl_tree_add(e2, &ubi->free);
> +                       ubi->free_count++;
>                         goto out_cancel;
>                 }
>                 self_check_in_wl_tree(ubi, e1, &ubi->used);
> --

Acked-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
