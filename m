Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3CKPBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:01:42 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:45919 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3CKPBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:01:40 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, abartlet@samba.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: Re: [PATCH v3] fat: editions to support fat_fallocate
References: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com>
	<87sj44ac82.fsf@devron.myhome.or.jp>
	<CAKYAXd_E8ZzutRVX6bCpzuosVLqsCDk0VzPYeXtcG8K+4wwBvQ@mail.gmail.com>
Date: Tue, 12 Mar 2013 00:01:35 +0900
In-Reply-To: <CAKYAXd_E8ZzutRVX6bCpzuosVLqsCDk0VzPYeXtcG8K+4wwBvQ@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 11 Mar 2013 18:52:25 +0900")
Message-ID: <87620y2d68.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> This choose ->release(). BTW, we would also be able to do this only
>> ->evict_inode(), although I'm not thinking yet which one is better.
>>
>> If you had conclusion, it would be nice to explain it.
> evict_inode() will be called only when we unlink the file or if inode
> is evicted from cache.
> As we discussed with you before, We considered preallocated blocks is
> discarded on all close file cases(unlink and muliple openning file).
> So we think it would be better to do this in ->release().

If so, probably, I didn't clear my opinion/suggestion, or misled
you. Sorry about it.

My opinion/suggestion is, "it should be before umount()".
I.e. fallocate() doesn't have any affect to FAT on clean state (clean
umount).

To clear my state, I don't have strong opinion about implementation yet.
For example, about ->release() or ->evict_inode().

So, if you had reason to use ->release() over "we discussed", it would
be good. (Or, if you still didn't have reasons, we would be better to
think about it)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
