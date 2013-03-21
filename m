Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3CUClm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:41:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:22953 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3CUClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:41:40 -0400
Message-ID: <514A7340.5040409@huawei.com>
Date: Thu, 21 Mar 2013 10:41:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com> <1363793126-11510-2-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1363793126-11510-2-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/20 23:25, Ming Lei wrote:
> While readdir() is running, lseek() may set filp->f_pos as zero,
> then may leave filp->private_data pointing to one sysfs_dirent
> object without holding its reference counter, so the sysfs_dirent
> object may be used after free in next readdir().
> 
> This patch holds inode->i_mutex to avoid the problem since
> the lock is always held in readdir path.
> 

In fact the same race exists between readdir() and read()/write()...

> Reported-by: Dave Jones <davej@redhat.com>
> Tested-by: Sasha Levin <levinsasha928@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  fs/sysfs/dir.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

