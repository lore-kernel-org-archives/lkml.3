Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaBFGlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 01:41:14 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35228 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaBFGlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 01:41:12 -0500
MIME-Version: 1.0
In-Reply-To: <87txcfudzu.fsf@devron.myhome.or.jp>
References: <1387953050-2692-1-git-send-email-linkinjeon@gmail.com>
	<87ioswx1xq.fsf@devron.myhome.or.jp>
	<CAKYAXd91w8rtXpq45Ckj+6kGWAnn9Gj80EezpomyXO6+yggivQ@mail.gmail.com>
	<87y51rue2a.fsf@devron.myhome.or.jp>
	<87txcfudzu.fsf@devron.myhome.or.jp>
Date: Thu, 6 Feb 2014 15:41:11 +0900
Message-ID: <CAKYAXd91uHuT=Dze9BHY_LjHq2tB=HO83fxeRsnWzt-vRcwoyA@mail.gmail.com>
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

2014-02-04, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>>>> Don't we need to update ->i_disksize after cont_write_begin()?
>>> We don't need to update i_disksize after cont_write_begin.
>>> It is taken care by the fat_get_block after the allocation.
>>> For all write paths we align the mmu_private and i_disksize from
>>> fat_fill_inode and fat_get_block.
>>
>> fat_fill_inode() just set i_disksize to i_size. So, it is not aligned by
>> cluster size or block size.
>>
>> E.g. ->mmu_private = 500. Then, cont_write_begin() can set ->mmu_private
>> to 512 on some case. In this case, fat_get_block() will not be called,
>> because no new allocation.
>>
>> If this is true, it would be possible to have ->mmu_private == 512 and
>> ->i_disksize == 500.
>>
>> I'm missing something?
>
> BTW, even if above was right, I'm not checking whether updating
> ->i_disksize after cont_write_begin() is right fix or not.
I understand your concern. these can be mismatched.
But, when checking your doubt, I can not find any side effect.
I think that there is no issue regardless of alignment of two value,
in the cont_write_begin.
Could you please share any point I am missing ?
If you suggest checking point or test method, I can check more and
share the result.

Thanks OGAWA.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
