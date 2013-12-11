Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab3LKFzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:55:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:32948 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3LKFzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:55:50 -0500
Message-ID: <52A7FE5E.3040307@huawei.com>
Date: Wed, 11 Dec 2013 13:55:42 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RESEND 1/2] proc: change return values while get_proc_task
 err
References: <1386591115-39392-1-git-send-email-rui.xiang@huawei.com> <20131210150241.5b741b8754112b1ab6d3abd6@linux-foundation.org>
In-Reply-To: <20131210150241.5b741b8754112b1ab6d3abd6@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/11 7:02, Andrew Morton wrote:
> On Mon, 9 Dec 2013 20:11:54 +0800 Rui Xiang <rui.xiang@huawei.com> wrote:
> 
>> While getting proc task error, it shoule return -ESRCH.
>>
>> ...
>>
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -174,9 +174,10 @@ static int get_task_root(struct task_struct *task, struct path *root)
>>  static int proc_cwd_link(struct dentry *dentry, struct path *path)
>>  {
>>  	struct task_struct *task = get_proc_task(dentry->d_inode);
>> -	int result = -ENOENT;
>> +	int result = -ESRCH;
> 
> I suppose so.  But there is risk here of breaking existing applications
> and I don't think this problem is serious enough to justify that risk?
> 
Got it. Thanks for your comment.

Thanks
 Rui


