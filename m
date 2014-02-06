Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbaBFMSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:18:24 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51479 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbaBFMSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:18:22 -0500
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
	<87txcfudzu.fsf@devron.myhome.or.jp>
	<CAKYAXd91uHuT=Dze9BHY_LjHq2tB=HO83fxeRsnWzt-vRcwoyA@mail.gmail.com>
Date: Thu, 06 Feb 2014 21:18:13 +0900
In-Reply-To: <CAKYAXd91uHuT=Dze9BHY_LjHq2tB=HO83fxeRsnWzt-vRcwoyA@mail.gmail.com>
	(Namjae Jeon's message of "Thu, 6 Feb 2014 15:41:11 +0900")
Message-ID: <87ppn0v3i2.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> fat_fill_inode() just set i_disksize to i_size. So, it is not aligned by
>>> cluster size or block size.
>>>
>>> E.g. ->mmu_private = 500. Then, cont_write_begin() can set ->mmu_private
>>> to 512 on some case. In this case, fat_get_block() will not be called,
>>> because no new allocation.
>>>
>>> If this is true, it would be possible to have ->mmu_private == 512 and
>>> ->i_disksize == 500.
>>>
>>> I'm missing something?
>>
>> BTW, even if above was right, I'm not checking whether updating
>> ->i_disksize after cont_write_begin() is right fix or not.
> I understand your concern. these can be mismatched.  But, when
> checking your doubt, I can not find any side effect.  I think that
> there is no issue regardless of alignment of two value, in the
> cont_write_begin.  Could you please share any point I am missing ?  If
> you suggest checking point or test method, I can check more and share
> the result.

I'm not checking whether it is wrong or not. But, like you said,
->mmu_private > ->i_disksize is wrong in theory.

Although, it might have no real problem.

So, how about to set ->i_disksize to aligned by blocksize at first
(i.e. when initializing the inode)?

This may change the behavior when ->mmu_private is not aligned to
blocksize in current patchset. But, in theory, it is right state
(between ->mmu_private and ->i_disksize is uninitialized). I guess, we
can do it with small adjustments, and keep state valid in theory too.

This is just a my guess, so it might be wrong though. I guess, worth to
try to consider.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
