Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab3DZBoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 21:44:06 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34002 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759541Ab3DZBoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <1366887697-24627-3-git-send-email-jaegeuk.kim@samsung.com>
References: <1366887697-24627-1-git-send-email-jaegeuk.kim@samsung.com>
	<1366887697-24627-3-git-send-email-jaegeuk.kim@samsung.com>
Date: Fri, 26 Apr 2013 10:44:03 +0900
Message-ID: <CAKYAXd_f8Vqd=zrUf0PpccuJFtUF5rW-74wt4oac2M0etT5YVA@mail.gmail.com>
Subject: Re: [PATCH 3/3] f2fs: enhnace alloc_nid and build_free_nids flows
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> In order to avoid build_free_nid lock contention, let's change the order of
> function calls as follows.
>
> At first, check whether there is enough free nids.
>  - If available, just get a free nid with spin_lock without any overhead.
>  - Otherwise, conduct build_free_nids.
>   : scan nat pages, journal nat entries, and nat cache entries.
>
> We should consider carefullly not to serve free nids intermediately made by
> build_free_nids.
> We can get stable free nids only after build_free_nids is done.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
I can't find any issues in this patch.
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
> ---
