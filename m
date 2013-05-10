Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3EJITP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:19:15 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:54606 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3EJISd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:18:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Lars Ellenberg'" <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 3.9-stable ]drbd: fix for deadlock when using automatic split-brain-recovery
Date: Fri, 10 May 2013 10:18:27 +0200
Message-ID: <1428383.d3PqBhHJle@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-40-lowlatency; KDE/4.8.5; x86_64; ; )
In-Reply-To: <003801ce4c41$d52a0890$7f7e19b0$%choi@samsung.com>
References: <003801ce4c41$d52a0890$7f7e19b0$%choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please.

> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?
> 
> ------------------
> 
> From: "Philipp Reisner <philipp.reisner@linbit.com>"
> 
> commit 7c689e63a847316c1b2500f86891b0a574ce7e69 upstream
> 
> With an automatic after split-brain recovery policy of
> "after-sb-1pri call-pri-lost-after-sb",
> when trying to drbd_set_role() to R_SECONDARY,
> we run into a deadlock.
> 
> This was first recognized and supposedly fixed by
> 2009-06-10 "Fixed a deadlock when using automatic split brain recovery when
> both nodes are"
> replacing drbd_set_role() with drbd_change_state() in that code-path,
> but the first hunk of that patch forgets to remove the drbd_set_role().
> 
> We apparently only ever tested the "two primaries" case.
> 
> Cc: <stable@vger.kernel.org> # 3.9.x: ef57f9e6: drbd: Fix build error
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/block/drbd/drbd_receiver.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/drbd/drbd_receiver.c
> b/drivers/block/drbd/drbd_receiver.c
> index a9eccfc..5105f43 100644
> --- a/drivers/block/drbd/drbd_receiver.c
> +++ b/drivers/block/drbd/drbd_receiver.c
> @@ -2661,7 +2661,6 @@ static int drbd_asb_recover_1p(struct drbd_conf *mdev)
> __must_hold(local)
>  		if (hg == -1 && mdev->state.role == R_PRIMARY) {
>  			enum drbd_state_rv rv2;
> 
> -			drbd_set_role(mdev, R_SECONDARY, 0);
>  			 /* drbd_change_state() does not sleep while in
> SS_IN_TRANSIENT_STATE,
>  			  * we might be here in C_WF_REPORT_PARAMS which is
> transient.
>  			  * we do not need to wait for the after state
> change work either. */
