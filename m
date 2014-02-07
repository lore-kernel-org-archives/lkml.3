Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaBGEXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:23:50 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:38384 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBGEXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:23:48 -0500
MIME-Version: 1.0
In-Reply-To: <87ppn0v3i2.fsf@devron.myhome.or.jp>
References: <1387953050-2692-1-git-send-email-linkinjeon@gmail.com>
	<87ioswx1xq.fsf@devron.myhome.or.jp>
	<CAKYAXd91w8rtXpq45Ckj+6kGWAnn9Gj80EezpomyXO6+yggivQ@mail.gmail.com>
	<87y51rue2a.fsf@devron.myhome.or.jp>
	<87txcfudzu.fsf@devron.myhome.or.jp>
	<CAKYAXd91uHuT=Dze9BHY_LjHq2tB=HO83fxeRsnWzt-vRcwoyA@mail.gmail.com>
	<87ppn0v3i2.fsf@devron.myhome.or.jp>
Date: Fri, 7 Feb 2014 13:23:47 +0900
Message-ID: <CAKYAXd9aTdk=21jTxtMcTjpxH9VuqrCTGgyTDkzD2NYKaGKB3g@mail.gmail.com>
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

2014-02-06, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> fat_fill_inode() just set i_disksize to i_size. So, it is not aligned
>>>> by
>>>> cluster size or block size.
>>>>
>>>> E.g. ->mmu_private = 500. Then, cont_write_begin() can set
>>>> ->mmu_private
>>>> to 512 on some case. In this case, fat_get_block() will not be called,
>>>> because no new allocation.
>>>>
>>>> If this is true, it would be possible to have ->mmu_private == 512 and
>>>> ->i_disksize == 500.
>>>>
>>>> I'm missing something?
>>>
>>> BTW, even if above was right, I'm not checking whether updating
>>> ->i_disksize after cont_write_begin() is right fix or not.
>> I understand your concern. these can be mismatched.  But, when
>> checking your doubt, I can not find any side effect.  I think that
>> there is no issue regardless of alignment of two value, in the
>> cont_write_begin.  Could you please share any point I am missing ?  If
>> you suggest checking point or test method, I can check more and share
>> the result.
>
> I'm not checking whether it is wrong or not. But, like you said,
> ->mmu_private > ->i_disksize is wrong in theory.
>
> Although, it might have no real problem.
>
> So, how about to set ->i_disksize to aligned by blocksize at first
> (i.e. when initializing the inode)?
Yes, It is good idea.
>
> This may change the behavior when ->mmu_private is not aligned to
> blocksize in current patchset. But, in theory, it is right state
> (between ->mmu_private and ->i_disksize is uninitialized). I guess, we
> can do it with small adjustments, and keep state valid in theory too.
Right.
>
> This is just a my guess, so it might be wrong though. I guess, worth to
> try to consider.
Okay, I will include it in next patch-set after checking.

Thanks for your review!
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
