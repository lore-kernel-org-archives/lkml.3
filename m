Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3FTG2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:28:13 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63337 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3FTG2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:28:12 -0400
MIME-Version: 1.0
In-Reply-To: <87txkvjpde.fsf@devron.myhome.or.jp>
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
	<CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
	<87bo8v42wx.fsf@devron.myhome.or.jp>
	<CAKYAXd_-Z8Avm-FmLF=MVqHSkzfE1_jczBroyFXv5xgQmr5=XA@mail.gmail.com>
	<87vc722cdu.fsf@devron.myhome.or.jp>
	<CAKYAXd8nTUrW04ADyDkhnJWyjUKiniU+r65J5SMhXT-jHTG+UA@mail.gmail.com>
	<87r4hp3kax.fsf@devron.myhome.or.jp>
	<87k3nh3jzi.fsf@devron.myhome.or.jp>
	<CAKYAXd_DRLG3KzjXEQ_8vD5mFWE95gR+jj3-MYhC3QKgQOLTEA@mail.gmail.com>
	<87fvy53eun.fsf@devron.myhome.or.jp>
	<CAKYAXd95yVtbEmwiaDaxgDsJYbqWDV23rY0GuPKLVf0msSGJ2g@mail.gmail.com>
	<CAKYAXd8kyN1w5GJ8zCoKL+XS67125dUf0ivqCQWKjGCSxnXYpg@mail.gmail.com>
	<87txkvjpde.fsf@devron.myhome.or.jp>
Date: Thu, 20 Jun 2013 15:28:11 +0900
Message-ID: <CAKYAXd-TUQ38DMdb13y6KFo6JikD48hAKhd30gWb4oHn68V_Og@mail.gmail.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/19, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>If above is correct, right implement to change get_block().
>> Now when we try to write in the fallocated region ( with keep size) in
>> the fat_write_begin when it is called first time it checks that the
>> mismatch is present between the mmu_private and mmu_actual , and hence
>> zero out the region ; since buffer_new is not set for fallocated
>> region by fat_get_block , we explicitly zero out the lseeked region
>> using "fat_zero_falloc_area" and normal write occurs beyond that , and
>> i_size is updated accordingly , and as such there is no need to move
>> the code to fat_get_block .
>
> OK. So, like I said, you *changed* the behavior of get_block() via
> fallocate() change, right?  (I think, now, you noticed fat_get_block()
> was changed.) Since you changed the behavior of get_block(), you had to
> hack write_begin(). (IMO, that patch is dirty hack to fix write_begin()
> path only)
>
> Likewise, you have to prove all callers of get_block() must work
> collectedly with that change.
>
Hi OGAWA.
> What happen on direct I/O, bmap ioctl, etc.? Well, anyway, please fix
> the root cause of change of behavior.
Good point!
Yes, I didn't consider direct I/O and bmap yet. Sure, I will fix it.
Thanks for review :)
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
