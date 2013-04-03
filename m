Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3DCF6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:58:51 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43267 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3DCF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <1364799360-23145-3-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-3-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 3 Apr 2013 14:58:49 +0900
Message-ID: <CAKYAXd_rkU5t=OOxjTu0CtKHfrTYkbJuJ2ZFNd=aaRsuToHU7A@mail.gmail.com>
Subject: Re: [PATCH 3/9] f2fs: remove redundant lock_page calls
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> In get_node_page, we do not need to call lock_page all the time.
>
> If the node page is cached as uptodate,
>
> 1. grab_cache_page locks the page,
> 2. read_node_page unlocks the page, and
> 3. lock_page is called for further process.
>
> Let's avoid this.
Instead of removing the function "read_node_page" completely to avoid
the redundant locking, we can simply remove the "unlock" part from the
read_node_page and use the same code in ra_node_page, get_node_page,
get_node_page_ra..
With this patch change, the same code is getting repeated at several
places and IMHO It is not good for the puprose of the modularity.
Please share your opinion.

Thanks.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
