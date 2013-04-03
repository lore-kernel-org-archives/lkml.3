Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441Ab3DCI1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:27:54 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35148 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761201Ab3DCI1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <1364976769.4353.11.camel@kjgkr>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-3-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd_rkU5t=OOxjTu0CtKHfrTYkbJuJ2ZFNd=aaRsuToHU7A@mail.gmail.com>
	<1364976769.4353.11.camel@kjgkr>
Date: Wed, 3 Apr 2013 17:27:51 +0900
Message-ID: <CAKYAXd9SEhxpqiGRqO_h+EkdqcmJ8Mm_cJtmrmYowmG1700njg@mail.gmail.com>
Subject: Re: [PATCH 3/9 v2] f2fs: remove redundant lock_page calls
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/3, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
Hi. Jaegeuk.
> Hi,
>
> Agreed, and send v2.
>
> Change log from v1:
>  o remain read_node_page and remove the lock part
>
> From 04006aecac2882c574fe8a7de926bc52c73a8ad1 Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Date: Sun, 31 Mar 2013 12:47:20 +0900
> Subject: [PATCH] f2fs: remove redundant lock_page calls
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-f2fs-devel@lists.sourceforge.net
>
> In get_node_page, we do not need to call lock_page all the time.
>
> If the node page is cached as uptodate,
>
> 1. grab_cache_page locks the page,
> 2. read_node_page unlocks the page, and
> 3. lock_page is called for further process.
>
> Let's avoid this.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Yes, Looks good!
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
> ---
