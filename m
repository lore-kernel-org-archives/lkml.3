Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab3FSP5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:57:39 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52011 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab3FSP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:57:36 -0400
Date: Wed, 19 Jun 2013 08:57:35 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: majianpeng <majianpeng@gmail.com>
cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: avoid meaningless calling ceph_caps_revoking if
 sync_mode == WB_SYNC_ALL.
In-Reply-To: <201306191512024406391@gmail.com>
Message-ID: <alpine.DEB.2.00.1306190857320.27900@cobra.newdream.net>
References: <201306191512024406391@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks!

sage

On Wed, 19 Jun 2013, majianpeng wrote:

> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  fs/ceph/addr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 3e68ac1..25fa8b8 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -677,8 +677,8 @@ static int ceph_writepages_start(struct address_space *mapping,
>  	 * integrity write (e.g., O_SYNC write or fsync()), or if our
>  	 * cap is being revoked.
>  	 */
> -	do_sync = wbc->sync_mode == WB_SYNC_ALL;
> -	if (ceph_caps_revoking(ci, CEPH_CAP_FILE_BUFFER))
> +	if ((wbc->sync_mode == WB_SYNC_ALL) ||
> +		ceph_caps_revoking(ci, CEPH_CAP_FILE_BUFFER))
>  		do_sync = 1;
>  	dout("writepages_start %p dosync=%d (mode=%s)\n",
>  	     inode, do_sync,
> -- 
> 1.8.3.rc1.44.gb387c77
> N????y????b?????v?????{.n??????z??ay????????j???f????????????????:+v??????????zZ+??????"?!?
