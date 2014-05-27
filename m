Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaE0PO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:14:59 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:43954 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaE0PO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:14:58 -0400
MIME-Version: 1.0
In-Reply-To: <1401117687-28911-14-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
	<1401117687-28911-14-git-send-email-benoit.taine@lip6.fr>
Date: Tue, 27 May 2014 11:14:57 -0400
Message-ID: <CADnq5_MMWZPqth1EFL0-790wk=mBb_GRz9BCmkzroEhOYniKUw@mail.gmail.com>
Subject: Re: [PATCH 13/18] drm/edid: Use kmemdup instead of kmalloc + memcpy
From: Alex Deucher <alexdeucher@gmail.com>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: David Airlie <airlied@linux.ie>, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 11:21 AM, Benoit Taine <benoit.taine@lip6.fr> wrote:
> This issue was reported by coccicheck using the semantic patch
> at scripts/coccinelle/api/memdup.cocci
>
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> ---
> Tested by compilation without errors.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

>
>  drivers/gpu/drm/drm_edid.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 7a4fd2e..d74239f 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -3228,10 +3228,9 @@ int drm_edid_to_speaker_allocation(struct edid *edid, u8 **sadb)
>
>                         /* Speaker Allocation Data Block */
>                         if (dbl == 3) {
> -                               *sadb = kmalloc(dbl, GFP_KERNEL);
> +                               *sadb = kmemdup(&db[1], dbl, GFP_KERNEL);
>                                 if (!*sadb)
>                                         return -ENOMEM;
> -                               memcpy(*sadb, &db[1], dbl);
>                                 count = dbl;
>                                 break;
>                         }
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
