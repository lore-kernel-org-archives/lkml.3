Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3J3FSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:18:46 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:45719 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3J3FSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:18:44 -0400
MIME-Version: 1.0
In-Reply-To: <87zjprwnsy.fsf@devron.myhome.or.jp>
References: <1381329640-11871-1-git-send-email-linkinjeon@gmail.com>
	<87hac2yga3.fsf@devron.myhome.or.jp>
	<CAKYAXd8sJce+asVXOsOHb3eC5VMxbfSFUTS=AFCmiDbc9tzobg@mail.gmail.com>
	<87zjprwnsy.fsf@devron.myhome.or.jp>
Date: Wed, 30 Oct 2013 14:18:43 +0900
Message-ID: <CAKYAXd9Dsj7P=WvnFuYqnMzO4+obXZzXODW4t-o8D6qgy28hdA@mail.gmail.com>
Subject: Re: [PATCH 2/5] fat: add fat_fallocate operation
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/30, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> +	/* Release unwritten fallocated blocks on file release. */
>>>> +	if (round_up(inode->i_size, sb->s_blocksize) <
>>>> +	    MSDOS_I(inode)->i_disksize && inode->i_nlink != 0)
>>>> +		fat_truncate_blocks(inode, inode->i_size);
>>>> +
>>>>  	truncate_inode_pages(&inode->i_data, 0);
>>>>  	if (!inode->i_nlink) {
>>>>  		inode->i_size = 0;
>
> [...]
>
>>> And inode->i_size should be ->mmu_private?
>> Sorry, I don't understand your question yet...
>> Could you elaborate more ?
>
> "if" part is checking "round_up(->i_size) < ->i_disksize", but I guess
> fallocate() truncation should be only needed if there is uninitialized
> data. So, I felt that part should check ->mmu_private and ->i_disksize.
Yes, right. I will change it as your points.
Thanks for review!!

>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
