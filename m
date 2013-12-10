Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab3LJXCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:02:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3LJXCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:02:42 -0500
Date: Tue, 10 Dec 2013 15:02:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rui Xiang <rui.xiang@huawei.com>
Cc: <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RESEND 1/2] proc: change return values while
 get_proc_task err
Message-Id: <20131210150241.5b741b8754112b1ab6d3abd6@linux-foundation.org>
In-Reply-To: <1386591115-39392-1-git-send-email-rui.xiang@huawei.com>
References: <1386591115-39392-1-git-send-email-rui.xiang@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 20:11:54 +0800 Rui Xiang <rui.xiang@huawei.com> wrote:

> While getting proc task error, it shoule return -ESRCH.
> 
> ...
>
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -174,9 +174,10 @@ static int get_task_root(struct task_struct *task, struct path *root)
>  static int proc_cwd_link(struct dentry *dentry, struct path *path)
>  {
>  	struct task_struct *task = get_proc_task(dentry->d_inode);
> -	int result = -ENOENT;
> +	int result = -ESRCH;

I suppose so.  But there is risk here of breaking existing applications
and I don't think this problem is serious enough to justify that risk?

