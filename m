Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3CLI3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:29:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34066 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3CLI3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:29:07 -0400
MIME-Version: 1.0
In-Reply-To: <87620y2d68.fsf@devron.myhome.or.jp>
References: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com>
	<87sj44ac82.fsf@devron.myhome.or.jp>
	<CAKYAXd_E8ZzutRVX6bCpzuosVLqsCDk0VzPYeXtcG8K+4wwBvQ@mail.gmail.com>
	<87620y2d68.fsf@devron.myhome.or.jp>
Date: Tue, 12 Mar 2013 17:29:05 +0900
Message-ID: <CAKYAXd_rettrtbYJoF4feBYTCWYOYGg_x1XbnNLyAZJBo7xa-Q@mail.gmail.com>
Subject: Re: [PATCH v3] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, abartlet@samba.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/12, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> This choose ->release(). BTW, we would also be able to do this only
>>> ->evict_inode(), although I'm not thinking yet which one is better.
>>>
>>> If you had conclusion, it would be nice to explain it.
>> evict_inode() will be called only when we unlink the file or if inode
>> is evicted from cache.
>> As we discussed with you before, We considered preallocated blocks is
>> discarded on all close file cases(unlink and muliple openning file).
>> So we think it would be better to do this in ->release().
>
> If so, probably, I didn't clear my opinion/suggestion, or misled
> you. Sorry about it.
>
> My opinion/suggestion is, "it should be before umount()".
> I.e. fallocate() doesn't have any affect to FAT on clean state (clean
> umount).
>
> To clear my state, I don't have strong opinion about implementation yet.
> For example, about ->release() or ->evict_inode().
>
> So, if you had reason to use ->release() over "we discussed", it would
> be good. (Or, if you still didn't have reasons, we would be better to
> think about it)
We considered all the possible points where we can release the
pre-allocated blocks.
As the "pre-allocation" is file based, we think it need to have
release mechanism.

In case of evict, Eviction will either happen when the file is removed
or the inode is evicted from the cache by memory pressure when no
references are present for that file.
It is good that evict will be triggered in umount. but there is a risk
that umount time can be increased.
And It show users inconsistent result. e.g sometime user can not get
file discarded fallocated blocks by memory pressure.

Let me know your opinion.

Thanks.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
