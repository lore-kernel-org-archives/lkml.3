Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaBDKUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:20:35 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:46569 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaBDKU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:20:28 -0500
MIME-Version: 1.0
In-Reply-To: <87ioswx1xq.fsf@devron.myhome.or.jp>
References: <1387953050-2692-1-git-send-email-linkinjeon@gmail.com>
	<87ioswx1xq.fsf@devron.myhome.or.jp>
Date: Tue, 4 Feb 2014 19:20:27 +0900
Message-ID: <CAKYAXd91w8rtXpq45Ckj+6kGWAnn9Gj80EezpomyXO6+yggivQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] fat: add i_disksize to represent uninitialized size
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-03, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Add i_disksize to represent uninitialized allocated size.
>> And mmu_private represent initialized allocated size.
>
> Don't we need to update ->i_disksize after cont_write_begin()?
We don't need to update i_disksize after cont_write_begin.
It is taken care by the fat_get_block after the allocation.
For all write paths we align the mmu_private and i_disksize from
fat_fill_inode and fat_get_block.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
