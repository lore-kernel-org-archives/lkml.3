Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaD0Wil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:38:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaD0Wik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:38:40 -0400
Date: Sun, 27 Apr 2014 15:39:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: Re: [PATCH 5/5] staging/lustre/lnet: fix potential null pointer
 dereference
Message-ID: <20140427223925.GC1563@kroah.com>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
 <1398633446-16719-6-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398633446-16719-6-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 05:17:26PM -0400, Oleg Drokin wrote:
> From: Dmitry Eremin <dmitry.eremin@intel.com>
> 
> Pointer 'ni' checked for NULL at line 1569 may be passed to
> function and may be dereferenced there by passing argument 1 to
> function 'lnet_ni_notify_locked' at line 1621.
> found by Klocwork Insight tool
> 
> Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
> Reviewed-on: http://review.whamcloud.com/9386
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
> Reviewed-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-by: Isaac Huang <he.huang@intel.com>
> Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
> ---
>  drivers/staging/lustre/lnet/lnet/router.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
> index 995f509..ba0278e 100644
> --- a/drivers/staging/lustre/lnet/lnet/router.c
> +++ b/drivers/staging/lustre/lnet/lnet/router.c
> @@ -1559,7 +1559,8 @@ lnet_notify(lnet_ni_t *ni, lnet_nid_t nid, int alive, cfs_time_t when)
>  
>  	lnet_notify_locked(lp, ni == NULL, alive, when);
>  
> -	lnet_ni_notify_locked(ni, lp);
> +	if (ni != NULL)
> +		lnet_ni_notify_locked(ni, lp);

Why can't lnet_ni_notify_locked() accept NULL as an input?

