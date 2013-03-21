Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3CUEsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 00:48:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56751 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3CUEsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 00:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <514A7E72.2090200@huawei.com>
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
	<1363793126-11510-2-git-send-email-ming.lei@canonical.com>
	<514A7340.5040409@huawei.com>
	<CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com>
	<514A7E72.2090200@huawei.com>
Date: Thu, 21 Mar 2013 12:48:36 +0800
Message-ID: <CACVXFVMS644BpX7voMHS-xXoRs9-G4y96=ubk_NAj6KDTy1ENQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
From: Ming Lei <ming.lei@canonical.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:28 AM, Li Zefan <lizefan@huawei.com> wrote:
> On 2013/3/21 11:17, Ming Lei wrote:
>> On Thu, Mar 21, 2013 at 10:41 AM, Li Zefan <lizefan@huawei.com> wrote:
>>>
>>> In fact the same race exists between readdir() and read()/write()...
>>
>> Fortunately, no read()/write() are implemented on sysfs directory, :-)
>>
>
> That's irrelevant...

As far as sysfs is concerned, the filp->f_ops can't be changed in
read/write path.

>
> See my report:
>
> https://patchwork.kernel.org/patch/2160771/

Yes, I know there might be some mess after the commit ef3d0fd2
(vfs: do (nearly) lockless generic_file_llseek).

Also looks it has been stated in Documentation/filesystems/Locking:

->llseek() locking has moved from llseek to the individual llseek
implementations.  If your fs is not using generic_file_llseek, you
need to acquire and release the appropriate locks in your ->llseek().
For many filesystems, it is probably safe to acquire the inode
mutex or just to use i_size_read() instead.
Note: this does not protect the file->f_pos against concurrent modifications
since this is something the userspace has to take care about.


Thanks,
--
Ming Lei
