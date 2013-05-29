Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965783Ab3E2Lpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:45:36 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34804 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965571Ab3E2Lpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:45:30 -0400
Message-ID: <51A5EA5D.6010408@inktank.com>
Date: Wed, 29 May 2013 06:45:33 -0500
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: Re: [patch] ceph: tidy ceph_mdsmap_decode() a little
References: <20130529062213.GF23932@mwanda>
In-Reply-To: <20130529062213.GF23932@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 01:22 AM, Dan Carpenter wrote:
> I introduced a new temporary variable "info" instead of
> "m->m_info[mds]".  Also I reversed the if condition and pulled
> everything in one indent level.

Looks good.  I will apply this for you.

Reviewed-by: Alex Elder <elder@inktank.com>

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This goes on top of Emil Goode's patch.
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index d4d3897..132b64e 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -92,6 +92,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  		u32 num_export_targets;
>  		void *pexport_targets = NULL;
>  		struct ceph_timespec laggy_since;
> +		struct ceph_mds_info *info;
>  
>  		ceph_decode_need(p, end, sizeof(u64)*2 + 1 + sizeof(u32), bad);
>  		global_id = ceph_decode_64(p);

. . .

