Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaJHHa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:30:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48094 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaJHHa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:30:28 -0400
Date: Wed, 8 Oct 2014 09:30:11 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: david.vrabel@citrix.com, konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xen/balloon: Don't continue ballooning when
 BP_ECANCELED is encountered
Message-ID: <20141008073011.GG3460@olila.local.net-space.pl>
References: <1412715607-16751-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412715607-16751-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:00:07PM -0400, Boris Ostrovsky wrote:
> Commit 3dcf63677d4e ("xen/balloon: cancel ballooning if adding new
> memory failed") makes reserve_additional_memory() return BP_ECANCELED
> when an error is encountered. This error, however, is ignored by the
> caller (balloon_process()) since it is overwritten by subsequent call
> to update_schedule(). This results in continuous attempts to add more
> memory, all of which are likely to fail again.
>
> We should stop trying to schedule next iteration of ballooning when
> the current one has failed.
>
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
> v2: Move status test to update_schedule()
>
>  drivers/xen/balloon.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 1e0a317..3860d02 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -167,6 +167,9 @@ static struct page *balloon_next_page(struct page *page)
>
>  static enum bp_state update_schedule(enum bp_state state)
>  {
> +	if (state == BP_ECANCELED)
> +		return BP_ECANCELED;
> +
>  	if (state == BP_DONE) {
>  		balloon_stats.schedule_delay = 1;
>  		balloon_stats.retry_count = 1;

Thanks. Please next time send Linux Kernel patches to LKML too.
Cc-ing it just in case.

Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

Daniel
