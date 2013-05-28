Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934690Ab3E1Pyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:54:50 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44822 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934550Ab3E1Pyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:54:49 -0400
Date: Tue, 28 May 2013 08:54:48 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Emil Goode <emilgoode@gmail.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ceph: improve error handling in ceph_mdsmap_decode
In-Reply-To: <1369753140-28802-1-git-send-email-emilgoode@gmail.com>
Message-ID: <alpine.DEB.2.00.1305280854370.12414@cobra.newdream.net>
References: <1369753140-28802-1-git-send-email-emilgoode@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to ceph tree; thanks!

On Tue, 28 May 2013, Emil Goode wrote:

> This patch makes the following improvements to the error handling
> in the ceph_mdsmap_decode function:
> 
> - Add a NULL check for return value from kcalloc
> - Make use of the variable err
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  fs/ceph/mdsmap.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 9278dec..d4d3897 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -138,6 +138,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  				m->m_info[mds].export_targets =
>  					kcalloc(num_export_targets, sizeof(u32),
>  						GFP_NOFS);
> +				if (m->m_info[mds].export_targets == NULL)
> +					goto badmem;
>  				for (j = 0; j < num_export_targets; j++)
>  					m->m_info[mds].export_targets[j] =
>  					       ceph_decode_32(&pexport_targets);
> @@ -170,7 +172,7 @@ bad:
>  		       DUMP_PREFIX_OFFSET, 16, 1,
>  		       start, end - start, true);
>  	ceph_mdsmap_destroy(m);
> -	return ERR_PTR(-EINVAL);
> +	return ERR_PTR(err);
>  }
>  
>  void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
