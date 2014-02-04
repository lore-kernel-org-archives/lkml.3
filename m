Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaBDOwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:52:41 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:50660 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaBDOw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:52:27 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 1/6] fat: add i_disksize to represent uninitialized size
References: <1387953050-2692-1-git-send-email-linkinjeon@gmail.com>
	<87ioswx1xq.fsf@devron.myhome.or.jp>
	<CAKYAXd91w8rtXpq45Ckj+6kGWAnn9Gj80EezpomyXO6+yggivQ@mail.gmail.com>
	<87y51rue2a.fsf@devron.myhome.or.jp>
Date: Tue, 04 Feb 2014 23:52:21 +0900
In-Reply-To: <87y51rue2a.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Tue, 04 Feb 2014 23:50:53 +0900")
Message-ID: <87txcfudzu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>>> Don't we need to update ->i_disksize after cont_write_begin()?
>> We don't need to update i_disksize after cont_write_begin.
>> It is taken care by the fat_get_block after the allocation.
>> For all write paths we align the mmu_private and i_disksize from
>> fat_fill_inode and fat_get_block.
>
> fat_fill_inode() just set i_disksize to i_size. So, it is not aligned by
> cluster size or block size.
>
> E.g. ->mmu_private = 500. Then, cont_write_begin() can set ->mmu_private
> to 512 on some case. In this case, fat_get_block() will not be called,
> because no new allocation.
>
> If this is true, it would be possible to have ->mmu_private == 512 and
> ->i_disksize == 500. 
>
> I'm missing something?

BTW, even if above was right, I'm not checking whether updating
->i_disksize after cont_write_begin() is right fix or not.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
