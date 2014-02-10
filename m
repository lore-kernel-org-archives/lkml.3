Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaBJMbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:31:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaBJMbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:31:18 -0500
Subject: Re: [PATCH 10/21] fs: Mark functions as static in gfs2/rgrp.c
From: Steven Whitehouse <swhiteho@redhat.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        josh@joshtriplett.org
In-Reply-To: <ea8cd448204387985f76078b8649168baaf81ab4.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
	 <ea8cd448204387985f76078b8649168baaf81ab4.1391949868.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 10 Feb 2014 12:30:20 +0000
Message-ID: <1392035420.2726.16.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2014-02-09 at 18:40 +0530, Rashika Kheria wrote:
> Mark functions as static in gfs2/rgrp.c because they are not used
> outside this file.
> 
> This eliminates the following warning in gfs2/rgrp.c:
> fs/gfs2/rgrp.c:1092:5: warning: no previous prototype for ‘gfs2_rgrp_bh_get’ [-Wmissing-prototypes]
> fs/gfs2/rgrp.c:1157:5: warning: no previous prototype for ‘update_rgrp_lvb’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  fs/gfs2/rgrp.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Now in the GFS2 -nmw tree. Thanks,

Steve.

> diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
> index a1da213..551b9e9 100644
> --- a/fs/gfs2/rgrp.c
> +++ b/fs/gfs2/rgrp.c
> @@ -1102,7 +1102,7 @@ static u32 count_unlinked(struct gfs2_rgrpd *rgd)
>   * Returns: errno
>   */
>  
> -int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
> +static int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
>  {
>  	struct gfs2_sbd *sdp = rgd->rd_sbd;
>  	struct gfs2_glock *gl = rgd->rd_gl;
> @@ -1169,7 +1169,7 @@ fail:
>  	return error;
>  }
>  
> -int update_rgrp_lvb(struct gfs2_rgrpd *rgd)
> +static int update_rgrp_lvb(struct gfs2_rgrpd *rgd)
>  {
>  	u32 rl_flags;
>  


