Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3KNWZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:25:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19602 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3KNWZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:25:09 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1384464592-35970-1-git-send-email-tim.gardner@canonical.com>
References: <1384464592-35970-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 3.13-rc1] xen-blkfront: Silence pfn maybe-uninitialized warning
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 14 Nov 2013 17:24:53 -0500
To: Tim Gardner <tim.gardner@canonical.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>
Message-ID: <17a2e4ab-d2dc-4bcc-a0fc-1eb1172876e5@email.android.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> wrote:
>pfn cannot actually be used unless (!info->feature_persistent), nor is
>pfn accessed in get_grant() unless (!info->feature_persistent), but
>silence
>this warning anyway. gcc-4.8
>
>drivers/block/xen-blkfront.c: In function 'do_blkif_request':
>drivers/block/xen-blkfront.c:508:20: warning: 'pfn' may be used
>uninitialized in this function [-Wmaybe-uninitialized]
>     gnt_list_entry = get_grant(&gref_head, pfn, info);
>                    ^
>drivers/block/xen-blkfront.c:492:19: note: 'pfn' was declared here
>     unsigned long pfn;
>
>Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>Cc: David Vrabel <david.vrabel@citrix.com>
>Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>---
> drivers/block/xen-blkfront.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/block/xen-blkfront.c
>b/drivers/block/xen-blkfront.c
>index 432db1b..5f926de 100644
>--- a/drivers/block/xen-blkfront.c
>+++ b/drivers/block/xen-blkfront.c
>@@ -489,7 +489,7 @@ static int blkif_queue_request(struct request *req)
> 
> 			if ((ring_req->operation == BLKIF_OP_INDIRECT) &&
> 			    (i % SEGS_PER_INDIRECT_FRAME == 0)) {
>-				unsigned long pfn;
>+				unsigned long uninitialized_var(pfn);
> 
> 				if (segments)
> 					kunmap_atomic(segments);

I have a similar patch from Roger that sets pfn=0. 

Roger could you repost your patch please or if you feel that this patch makes sense then comment on it?

Thanks.
