Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LRCjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:39:17 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:51800 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3LRCjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:39:15 -0500
Message-ID: <52B10AC7.4080107@huawei.com>
Date: Wed, 18 Dec 2013 10:39:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <hui.geng@huawei.com>,
        Wang Guoli <andy.wangguoli@huawei.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] jffs2: unlock f->sem on error in jffs2_new_inode()
References: <1387332894-33977-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1387332894-33977-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch should be sent to jffs2 mainling list, which is
linux-mtd@lists.infradead.org.

It's not needed to cc stable mailing list. Actually I think it's
better not to.

On 2013/12/18 10:14, Wang Nan wrote:
> From: Wang Guoli <andy.wangguoli@huawei.com>
> 
> If jffs2_new_inode() succeeds, it returns with f->sem held, and
> the caller is responsible for releasing the lock. If it fails,
> it still returns with the lock held, but the caller won't release
> the lock, which will lead to deadlock.
> 
> Fix it by releasing the lock in jffs2_new_inode() on error.
> 
> Cc: <stable@vger.kernel.org> # 2.6.34+
> Signed-off-by: Wang Guoli <andy.wangguoli@huawei.com>

You should also sign the patch.

> ---
>  fs/jffs2/fs.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

