Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab3FRRdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:33:08 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44002 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab3FRRdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:33:06 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
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
Date: Wed, 19 Jun 2013 02:33:01 +0900
In-Reply-To: <CAKYAXd8kyN1w5GJ8zCoKL+XS67125dUf0ivqCQWKjGCSxnXYpg@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 18 Jun 2013 14:47:10 +0900")
Message-ID: <87txkvjpde.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>If above is correct, right implement to change get_block().
> Now when we try to write in the fallocated region ( with keep size) in
> the fat_write_begin when it is called first time it checks that the
> mismatch is present between the mmu_private and mmu_actual , and hence
> zero out the region ; since buffer_new is not set for fallocated
> region by fat_get_block , we explicitly zero out the lseeked region
> using "fat_zero_falloc_area" and normal write occurs beyond that , and
> i_size is updated accordingly , and as such there is no need to move
> the code to fat_get_block .

OK. So, like I said, you *changed* the behavior of get_block() via
fallocate() change, right?  (I think, now, you noticed fat_get_block()
was changed.) Since you changed the behavior of get_block(), you had to
hack write_begin(). (IMO, that patch is dirty hack to fix write_begin()
path only)

Likewise, you have to prove all callers of get_block() must work
collectedly with that change.

What happen on direct I/O, bmap ioctl, etc.? Well, anyway, please fix
the root cause of change of behavior.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
