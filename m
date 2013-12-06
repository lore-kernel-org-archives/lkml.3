Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3LFIfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:35:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34157 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3LFIfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:35:18 -0500
X-AuditID: cbfee61a-b7f796d000004313-9a-52a18c446b0c
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1386310509-5864-1-git-send-email-jaegeuk.kim@samsung.com>
In-reply-to: <1386310509-5864-1-git-send-email-jaegeuk.kim@samsung.com>
Subject: RE: [PATCH] f2fs: add unlikely() macro for compiler more aggressively
Date: Fri, 06 Dec 2013 16:34:07 +0800
Message-id: <000401cef25e$16f97d60$44ec7820$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJcF0Q5wP6r8DsEcS1NqO5Q+LT82Jksb9kA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQV2XnoVBBkuXKVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldF86S1zwXzeiq17
	n7I1MK7l6mLk5JAQMJG4sKaLGcIWk7hwbz1bFyMXh5DAdEaJLfseMoEkhAR+MEpcW+8FYrMJ
	qEgs7/gPFhcR0Jb4ObeVHcRmFsiUmPN6MitEvZvE35lH2EBsTgF3ia3vmsFsYQE/iUcn74P1
	sgioSlw4ORHM5hWwlDi6tokZwhaU+DH5HgvETC2J9TuPM0HY8hKb17yFOlRBYsfZ14wQNxhJ
	PL+8EOoGcYmNR26xTGAUmoVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGMGB/0xqB+PKBotDjAIcjEo8vByrFgQJsSaWFVfmHmKU4GBWEuHtEV8YJMSbklhZlVqU
	H19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoGxsl0iu/W8yEe/7C/mKcWb
	jwUdatTnW/ja6a/OBZlV8X7L931IbNf0Vl+sW/nKnbE8/exNd34vg6otu7615of6hsstiw5R
	UnMzWjUjpTWNKyJ1R4L4ht3uttMKfsVvCdssXDVtVuCdRz/EV2bURBRs8C8vk06ePNGYm2lF
	2vLCq7vV0qK3rFZiKc5INNRiLipOBABH3DyJeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Friday, December 06, 2013 2:15 PM
> Cc: Jaegeuk Kim; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; Chao Yu
> Subject: [PATCH] f2fs: add unlikely() macro for compiler more aggressively
> 
> This patch adds unlikely() macro into the most of codes.
> The basic rule is to add that when:
> - checking unusual errors,
> - checking page mappings,
> - and the other unlikely conditions.

Looks nice to me!

> 
> Cc: Chao Yu <chao2.yu@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/checkpoint.c |  22 ++++++----
>  fs/f2fs/data.c       |  63 +++++++++++++--------------
>  fs/f2fs/dir.c        |  10 ++---
>  fs/f2fs/file.c       |  23 +++++-----
>  fs/f2fs/gc.c         |  19 ++++-----
>  fs/f2fs/inode.c      |  12 +++---
>  fs/f2fs/namei.c      |  24 ++++++-----
>  fs/f2fs/node.c       | 117 +++++++++++++++++++++++++++------------------------
>  fs/f2fs/recovery.c   |  10 ++---
>  fs/f2fs/segment.c    |  42 +++++++++---------
>  fs/f2fs/super.c      |  83 ++++++++++++++++++------------------
>  fs/f2fs/xattr.c      |  28 ++++++------
>  12 files changed, 234 insertions(+), 219 deletions(-)

[snip]

> @@ -808,11 +808,11 @@ retry:
>  		brelse(*raw_super_buf);
>  		f2fs_msg(sb, KERN_ERR, "Can't find a valid F2FS filesystem "
>  				"in %dth superblock", block + 1);
> -		if(block == 0) {
> +		if(unlikely(block != 0)) {

Original code has style problem:
Space is required before the open parenthesis '('.
Thanks.


