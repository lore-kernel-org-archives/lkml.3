Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3J3B13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:27:29 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:36362 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3J3B11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:27:27 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 2/5] fat: add fat_fallocate operation
References: <1381329640-11871-1-git-send-email-linkinjeon@gmail.com>
	<87hac2yga3.fsf@devron.myhome.or.jp>
	<CAKYAXd8sJce+asVXOsOHb3eC5VMxbfSFUTS=AFCmiDbc9tzobg@mail.gmail.com>
Date: Wed, 30 Oct 2013 10:27:25 +0900
In-Reply-To: <CAKYAXd8sJce+asVXOsOHb3eC5VMxbfSFUTS=AFCmiDbc9tzobg@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 30 Oct 2013 08:24:45 +0900")
Message-ID: <87zjprwnsy.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> +	/* Release unwritten fallocated blocks on file release. */
>>> +	if (round_up(inode->i_size, sb->s_blocksize) <
>>> +	    MSDOS_I(inode)->i_disksize && inode->i_nlink != 0)
>>> +		fat_truncate_blocks(inode, inode->i_size);
>>> +
>>>  	truncate_inode_pages(&inode->i_data, 0);
>>>  	if (!inode->i_nlink) {
>>>  		inode->i_size = 0;

[...]

>> And inode->i_size should be ->mmu_private?
> Sorry, I don't understand your question yet...
> Could you elaborate more ?

"if" part is checking "round_up(->i_size) < ->i_disksize", but I guess
fallocate() truncation should be only needed if there is uninitialized
data. So, I felt that part should check ->mmu_private and ->i_disksize.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
