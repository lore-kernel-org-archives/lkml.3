Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab3FFJYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:24:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab3FFJYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:24:21 -0400
Subject: Re: [PATCH] GFS2: fix error propagation in init_threads()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
In-Reply-To: <1370467744-4533-1-git-send-email-khoroshilov@ispras.ru>
References: <1370467744-4533-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 06 Jun 2013 10:21:48 +0100
Message-ID: <1370510508.2744.2.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the -nmw tree. Thanks,

Steve.

On Thu, 2013-06-06 at 01:29 +0400, Alexey Khoroshilov wrote:
> If kthread_run() fails, init_threads() returns
> IS_ERR(p) instead of PTR_ERR(p).
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  fs/gfs2/ops_fstype.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index 60ede2a..0262c19 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -916,16 +916,16 @@ static int init_threads(struct gfs2_sbd *sdp, int undo)
>  		goto fail_quotad;
>  
>  	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
> -	error = IS_ERR(p);
> -	if (error) {
> +	if (IS_ERR(p)) {
> +		error = PTR_ERR(p);
>  		fs_err(sdp, "can't start logd thread: %d\n", error);
>  		return error;
>  	}
>  	sdp->sd_logd_process = p;
>  
>  	p = kthread_run(gfs2_quotad, sdp, "gfs2_quotad");
> -	error = IS_ERR(p);
> -	if (error) {
> +	if (IS_ERR(p)) {
> +		error = PTR_ERR(p);
>  		fs_err(sdp, "can't start quotad thread: %d\n", error);
>  		goto fail;
>  	}


