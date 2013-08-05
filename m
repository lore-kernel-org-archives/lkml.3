Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3HEEOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 00:14:12 -0400
Received: from cobra.newdream.net ([66.33.216.30]:40794 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3HEEOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 00:14:11 -0400
Date: Sun, 4 Aug 2013 21:14:10 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ceph: fix null pointer dereference
In-Reply-To: <1375675470.19205.2.camel@lizardlounge>
Message-ID: <alpine.DEB.2.00.1308042113580.5645@cobra.newdream.net>
References: <1375675470.19205.2.camel@lizardlounge>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks right, applied to the testing branch.

Thanks!
sage


On Sun, 4 Aug 2013, Nathaniel Yazdani wrote:

> 	When register_session() is given an out-of-range argument for mds,
> ceph_mdsmap_get_addr() will return a null pointer, which would be given to
> ceph_con_open() & be dereferenced, causing a kernel oops. This fixes bug #4685
> in the Ceph bug tracker <http://tracker.ceph.com/issues/4685>.
> 
> Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
> ---
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 187bf21..ddff072 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -414,6 +414,9 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  {
>  	struct ceph_mds_session *s;
>  
> +	if (mds >= mdsc->mdsmap->m_max_mds)
> +		return ERR_PTR(-EINVAL);
> +
>  	s = kzalloc(sizeof(*s), GFP_NOFS);
>  	if (!s)
>  		return ERR_PTR(-ENOMEM);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
