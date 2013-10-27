Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3J0Npl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:45:41 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35319 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3J0Npk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:45:40 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 3/5] fat: zero out seek range on _fat_get_block
References: <1381329653-11905-1-git-send-email-linkinjeon@gmail.com>
	<87sivmygnq.fsf@devron.myhome.or.jp>
Date: Sun, 27 Oct 2013 22:45:37 +0900
In-Reply-To: <87sivmygnq.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Sun, 27 Oct 2013 22:42:01 +0900")
Message-ID: <87ob6ayghq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
>> +			>> blocksize_bits;
>> +		disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>> +			>> blocksize_bits;
>> +		if (iblock >= last_block && iblock <= disk_block) {
>> +			MSDOS_I(inode)->mmu_private +=
>> +				*max_blocks << blocksize_bits;
>
> Hm, mmu_private is not increased by write_begin()?

Ah, ok. I understood what this is doing. Please ignore this comment.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
